/** @file poisson2d_example_adaptRef.cpp

    @brief Example for using the gsPoissonSolver with adaptive refinement with THB-splines.

    This file is part of the G+Smo library.

    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.

    Author(s): S. Kleiss
*/




#include <iostream>

#include <gismo.h>

#include <gsAssembler/gsAdaptiveRefUtils.h>

#include <gsAssembler/gsErrEstPoissonResidual.h>

using namespace std;
using namespace gismo;


template <typename T>
void gsSave(const T& obj, const std::string& fname)
{
    gsFileData<> fd;
    fd << obj;
    fd.dump(fname);
}


//S.Kleiss
//
//This is a test example for a illustrating the adaptive
//refinement procedure implemented in the gsPoissonAssembler
//
//Flags, parameters, geometry and prescribed exact solution
//are specified within the main() function

int main(int argc, char *argv[])
{
  int result = 0;

  // Number of initial uniform mesh refinements
  int initUnifRef;
  // Number of adaptive refinement loops
  int RefineLoopMax;

  // Flag for refinemet criterion
  // (see doxygen documentation of the free function
  // gsMarkElementsForRef explanation)
  int refCriterion;
  // Parameter for computing adaptive refinement threshold
  // (see doxygen documentation of the free function
  // gsMarkElementsForRef explanation)
  real_t refParameter;  // ...specified below with the examples

  // Flag whether final mesh should be plotted in ParaView
  bool plot;
  bool dump;

  try 
  {
      gsCmdLine cmd("Solving a PDE with adaptive refinement using THB-splines.");
      gsArgSwitch arg_plot("", "plot", "Plot resulting mesh in ParaView", cmd);
      gsArgVal<int> arg_ref("r", "refine", 
              "Maximum number of adaptive refinement steps to perform", 
              false, 2, "int", cmd);
      gsArgVal<int> arg_initref("i", "initial-ref", 
              "Initial number of uniform refinement steps to perform", 
              false, 2, "int", cmd);
      gsArgVal<int> arg_crit("c", "criterion", 
              "Criterion to be used for adaptive refinement (1-3, see documentation)", 
              false, 2, "int", cmd);
      gsArgVal<real_t> arg_parameter("p", "parameter", 
              "Parameter for adaptive refinement", 
              false, 0.85, "float", cmd);
      gsArgSwitch arg_dump("", "dump", "Write geometry and sequence of bases into XML files", cmd);

      cmd.parse(argc,argv);

      plot          = arg_plot.getValue();
      RefineLoopMax = arg_ref.getValue();
      initUnifRef   = arg_initref.getValue();
      refCriterion  = arg_crit.getValue();
      refParameter  = arg_parameter.getValue();
      dump          = arg_dump.getValue();

  } catch ( gsArgException& e )
  { cerr << "Error: " << e.error() << " " << e.argId() << endl; return -1; }



  // ****** Prepared test examples ******
  //
  // f       ... source term
  // g       ... exact solution
  // patches ... the computational domain given as object of gsMultiPatch
  //


  /*
  // ------ Example 1 ------

  // --- Unit square, with a spike of the source function at (0.25, 0.6)
  gsMFunctionExpr<>  f("if( (x-0.25)^2 + (y-0.6)^2 < 0.2^2, 1, 0 )", 2);
  gsMFunctionExpr<>  g("0", 2);
  gsMultiPatch<> patches( *safe(gsNurbsCreator<>::BSplineRectangle(0.0,0.0,2.0,1.0) ));

  //RefineLoopMax = 6;
  //refParameter = 0.6;

  // ^^^^^^ Example 1 ^^^^^^
  //*/

//  /*
  // ------ Example 2 ------

  // The classical example associated with the L-Shaped domain.
  // The exact solution has a singularity at the re-entrant corner at the origin.

  gsMFunctionExpr<>  f("0", 2);
  gsMFunctionExpr<>  g("if( y>0, ( (x^2+y^2)^(1.0/3.0) )*sin( (2*atan2(y,x) - pi)/3.0 ), ( (x^2+y^2)^(1.0/3.0) )*sin( (2*atan2(y,x) +3*pi)/3.0 ) )", 2);

  gsMultiPatch<> patches( *safe(gsNurbsCreator<>::BSplineLShape_p2C1()) );

  //RefineLoopMax = 8;
  //refParameter = 0.85;

  // ^^^^^^ Example 2 ^^^^^^
  //*/

  cout<<"Source function "<< f << endl;
  cout<<"Exact solution "<< g <<".\n" << endl;

  // Define Boundary conditions
  gsBoundaryConditions<> bcInfo;
  // Dirichlet BCs
  bcInfo.addCondition( boundary::west,  condition_type::dirichlet, &g );
  bcInfo.addCondition( boundary::east,  condition_type::dirichlet, &g );
  bcInfo.addCondition( boundary::north, condition_type::dirichlet, &g );
  bcInfo.addCondition( boundary::south, condition_type::dirichlet, &g );

  gsTensorBSpline<2,real_t> * geo = dynamic_cast< gsTensorBSpline<2,real_t> * >( & patches.patch(0) );
  cout << " --- Geometry:\n" << *geo << endl;
  cout << "Number of patches: " << patches.nPatches() << endl;

  if (dump)
      gsSave(*geo, "adapt_geo.xml");

  // With this gsTensorBSplineBasis, it's possible to call the THB-Spline constructor
  gsTHBSplineBasis<2,real_t> THB( geo->basis() );

  // Finally, create a vector (of length one) of this gsTHBSplineBasis
  gsMultiBasis<real_t> bases(THB);
  
  for (int i = 0; i < initUnifRef; ++i)
      bases.uniformRefine();

  if (dump)
      gsSave(bases[0], "adapt_basis_0.xml");

  // So, ready to start the adaptive refinement loop:
  for( int RefineLoop = 1; RefineLoop <= RefineLoopMax ; RefineLoop++ )
  {
      cout << "\n ====== Loop " << RefineLoop << " of " << RefineLoopMax << " ======" << endl << endl;

      cout <<"Basis: "<< bases[0] <<"\n";

      // Create solver... maybe not the smartest thing to set up a new solver
      // in each iteration loop, but good enough for now.
      gsPoissonAssembler<real_t> pa(patches,bases,bcInfo,f,
                                    dirichlet::elimination,iFace::glue);

      // Assemble matrix and rhs
      pa.assemble();

      // Solve system
      gsMatrix<> solVector = Eigen::ConjugateGradient<gsSparseMatrix<> >(pa.matrix() ).solve( pa.rhs() );
      
      // Construct the solution for plotting the mesh later
      gsField<> * sol = pa.constructSolution(solVector);

      // Set up and compute the L2-error to the known exact solution...
      gsNormL2<real_t> norm(*sol,g);
      // ...and the error estimate, which needs the right-hand-side.
      gsErrEstPoissonResidual<real_t> errEst(*sol,f);

      norm  .compute(true); // "true" stores element-wise errors
      errEst.compute(true);

      // Get the vector with element-wise local errors...
      const std::vector<real_t> & elError = norm.elementNorms();
      // ...or the vector with element-wise local error estimates.
      const std::vector<real_t> & elErrEst = errEst.elementNorms();

      // Mark elements for refinement, based on the computed local errors and
      // refCriterion and refParameter.
      std::vector<bool> elMarked( elError.size() );
      // Use the (in this case known) exact error...
      //gsMarkElementsForRef( elError, refCriterion, refParameter, elMarked);
      // ...or the error estimate.
      gsMarkElementsForRef( elErrEst, refCriterion, refParameter, elMarked);

      // Refine the elements of the mesh, based on elMarked.
      gsRefineMarkedElements( bases, elMarked);

      if (dump)
      {
          stringstream ss;
          ss << "adapt_basis_" << RefineLoop << ".xml";
          gsSave(bases[0], ss.str());
      }

      if ( (RefineLoop == RefineLoopMax) && plot)
      {
          // Write approximate solution to paraview files
          std::cout<<"Plotting in Paraview...\n";
          gsWriteParaview<>(*sol, "p2d_adaRef_sol", 1001, true);
          // Run paraview and plot the last mesh
          result = system("paraview p2d_adaRef_sol0_mesh.vtp &");
      }

      delete sol;
  }

  cout << "\nFinal basis: " << bases[0] << "\n";

  return result;
}
