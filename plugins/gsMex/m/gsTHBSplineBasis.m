% @file gsTHBSpline.m
%
%    @brief Matlab wrapper for gsTHBSplineBasis class
%
%    This file is part of the G+Smo library.
%
%    This Source Code Form is subject to the terms of the Mozilla Public
%    License, v. 2.0. If a copy of the MPL was not distributed with this
%    file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
%    Author(s): O. Chanon, P. Noertoft

classdef gsTHBSplineBasis < handle

    properties (SetAccess = private, Hidden = true)
        objectHandle; % Handle to the underlying C++ class instance
    end

    methods(Access = public)

        % Constructor - Create a new C++ class instance 
        function this = gsTHBSplineBasis(varargin)
            %gsTHBSplineBasis - construct a gsTHBSplineBasis object
            %
            %Usage:
            %  thb = gsTHBSplineBasis( file )
            %  OR
            %  thb = gsTHBSplineBasis( knots )
            %
            %Input:
            %  file: char, [1 x numChar].
            %    Name of input file from which to read/construct the
            %    gsTHBSplineBasis.
            %  OR
            %  knots: cell
            %    The cell element i contains the knot vector in the
            %    direction i.
            %
            %Output:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.

            if (nargin~=1 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            
            if (isa(varargin{1},'uint64'))
                this.objectHandle = varargin{1};
            else
                if (~( isa(varargin{1},'char') || isa(varargin{1},'cell') ))
                    error('Input argument no. 1 should be of type ''char'' or be a cell of knot vectors.')
                elseif (isa(varargin{1},'char') && (~exist(varargin{1},'file')))
                    error('File does not exist: %s.',varargin{1})
                end
                this.objectHandle = mex_gsTHBSplineBasis('constructor', class(varargin{1}), varargin{:});
            end
        end
        
        % Destructor - Destroy the C++ class instance
        function delete(this)
            %delete - delete a gsTHBSplineBasis object
            %
            %Usage:
            %  thb.delete()
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %
            %Output:
            %  (none)
        
            mex_gsTHBSplineBasis('destructor', this.objectHandle);
        end

        % dim - call class method
        function varargout = dim(this, varargin)
            %dim - dimension of the parameter space of a gsTHBSplineBasis object
            %
            %Usage:
            %  val = thb.dim()
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %
            %Output:
            %  val: double, [1 x 1].
            %    Dimension of the parameter space of the gsTHBSplineBasis.
            
            if (nargin~=1 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('accessor', this.objectHandle, 'dim',  varargin{:});
        end
        
        % numElements - call class method
        function varargout = numElements(this, varargin)
            %numElements - number of elements of a gsTHBSplineBasis object
            %
            %Usage:
            %  num = thb.numElements()
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %
            %Output:
            %  num: double, [1 x 1].
            %    Number of elements of the gsTHBSplineBasis.
            
            if (nargin~=1 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('accessor', this.objectHandle, 'numElements',  varargin{:});
        end
        
        % size - call class method
        function varargout = size(this, varargin)
            %size - size/number of degrees of freedom of a gsTHBSplineBasis 
            %   object
            %
            %Usage:
            %  num = thb.size()
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %
            %Output:
            %  num: double, [1 x 1].
            %    Size of the gsTHBSplineBasis.
            
            if (nargin~=1 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('accessor', this.objectHandle, 'size',  varargin{:});
        end

        % treeSize - call class method
        function varargout = treeSize(this, varargin)
            %treeSize - size of the tree of a gsTHBSplineBasis object
            %
            %Usage:
            %  num = thb.treeSize()
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %
            %Output:
            %  num: double, [1 x 1].
            %    Size of the tree of the gsTHBSplineBasis.
            
            if (nargin~=1 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('accessor', this.objectHandle, 'treeSize',  varargin{:});
        end
        
        % treeLeafSize - call class method
        function varargout = treeLeafSize(this, varargin)
            %treeLeafSize - size of the leaf in the tree of a gsTHBSplineBasis object
            %
            %Usage:
            %  num = thb.treeLeafSize()
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %
            %Output:
            %  num: double, [1 x 1].
            %    Size of the leaf in the tree of the gsTHBSplineBasis.
            
            if (nargin~=1 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('accessor', this.objectHandle, 'treeLeafSize',  varargin{:});
        end
        
        % support - call class method
        function varargout = support(this, varargin)
            %support - support of a gsTHBSplineBasis object
            %
            %Usage:
            %  supp = thb.support()
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %
            %Output:
            %  supp: double, [1 x 2*d].
            %    Support of the gsTHBSplineBasis, ordered like 
            %      [u1_min, ..., ud_min, u1_max, ..., ud_max]
            %    where d is the parametric dimennsion of the 
            %    gsTHBSplineBasis.
            
            if (nargin~=1 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('accessor', this.objectHandle, 'support',  varargin{:});
        end

        % maxLevel - call class method
        function varargout = maxLevel(this, varargin)
            %maxLevel - number of levels of a gsTHBSplineBasis object
            %
            %Usage:
            %  lev = thb.maxLevel()
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %
            %Output:
            %  lev: double, [1 x 1].
            %    Number of levels present in the hierarchy of the
            %    gsTHBSplineBasis object. 
            
            if (nargin~=1 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('accessor', this.objectHandle, 'maxLevel',  varargin{:});
        end
        
        % treePrintLeaves - call class method
        function varargout = treePrintLeaves(this, varargin)
            %treePrintLeaves - print the leaves in the tree of a gsTHBSplineBasis object
            %
            %Usage:
            %  thb.treePrintLeaves()
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %
            %Output:
            %  (none - outputs to the screen).
            
            if (nargin~=1 || nargout>0)
                error('Invalid number of input and/or output arguments.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('treePrintLeaves', this.objectHandle, varargin{:});
        end

        % degree - call class method
        function [varargout] = degree(this, varargin)
            %degree - the degree for a specified direction of a 
            %   gsTHBSplineBasis object
            %
            %Usage:
            %  deg = thb.degree( dir )
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %  dir: int, [1 x 1].
            %    Direction of space for which we want to know the degree of 
            %    the gsTHBSplineBasis.
            %
            %Output:
            %  deg: double, [1 x 1].
            %    Degree of the gsTHBSplineBasis object in direction dir. 
            
            if (nargin~=2 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            if (~isa(varargin{1},'numeric') || ~isscalar(varargin{1}) || ...
                    ~(mod(varargin{1},1)==0) || varargin{1}<1 || varargin{1}>this.dim())
                error('Input argument must be a non negative integer less than %d.', this.dim())
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('degree', this.objectHandle, varargin{:});
        end
        
        % eval - call class method
        function [varargout] = eval(this, varargin)
            %eval - evaluate a gsTHBSplineBasis object
            %
            %Usage:
            %  val = thb.eval( pts )
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %  pts: double, [d x numPts] or [numPts x d].
            %    Points in which to evaluate the gsTHBSplineBasis.
            %
            %Output:
            %  val: double, [numFun x numPts].
            %    Value of all active functions in each of the specified
            %    points.
            
            if (nargin~=2 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            if (~isa(varargin{1},'numeric') || ~ismatrix(varargin{1}))
                error('Input argument no. 1 must be numeric, 2-dimensional.')
            elseif (~isequal(size(varargin{1},2),this.dim()) && ~isequal(size(varargin{1},1),this.dim()))
                error('Input argument no. 1 must be numeric, 2-dimensional with one dimension equal to parametric dim.')
            elseif (isequal(size(varargin{1},2),this.dim()))
                varargin{1} = varargin{1}.';
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('eval', this.objectHandle, varargin{:});
        end

        % evalSingle - call class method
        function [varargout] = evalSingle(this, varargin)
            %evalSingle - evaluate a single function in a gsTHBSplineBasis object
            %
            %Usage:
            %  valSingle = thb.evalSingle( fun, pts )
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %  fun: double, [1 x 1].
            %    Index of function to evaluate.
            %  pts: double, [d x numPts].
            %    Points in which to evaluate the function.
            %
            %Output:
            %  val: double, [1 x numPts].
            %    Value of the specified function in each of the specified
            %    points.
            
            if (nargin~=3 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            if (~isa(varargin{1},'numeric') || ~isscalar(varargin{1}) || ...
                    ~(mod(varargin{1},1)==0) || varargin{1}<1)
                error('Input argument no. 1 must be an strictly positive integer.')
            elseif (~isa(varargin{2},'numeric') || ~ismatrix(varargin{2}) || ~isequal(size(varargin{2},1),this.dim()))
                error('Input argument no. 2 must be numeric, 2-dimensional, and with d rows.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('evalSingle', this.objectHandle, varargin{:});
        end
        
        % save - call class method
        function [varargout] = save(this, varargin)
            %save - save a gsTHBSplineBasis object as xml object
            %
            %Usage:
            %  thb.save();
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %
            %Output:
            %   (none - saved into an xml file)
            
            if (nargin~=2)
                error('Invalid number of input arguments.')
            end
            if (~(isa(varargin{1},'char')))
                error('Input argument no. 1 should be of type ''char''.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('save', this.objectHandle, varargin{:});
        end
        
        % knots - call class method
        function [varargout] = knots(this, varargin)
            %knots - returns the knot vector of a gsTHBSplineBasis object
            %   of the specified level on the specified direction
            %
            %Usage:
            %  knt = thb.knots( lev, dir )
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %  lev: int, [1 x 1].
            %    Index of the level of the hierarchy to consider.
            %  dir: int, [1 x 1].
            %    index of the direction of space to consider. 
            %
            %Output:
            %  knt: double, [1 x numKnots].
            %    Knot vector corresponding to level lev in the direction
            %    dir. 
            
            if (nargin~=3 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            if (~isa(varargin{1},'numeric') || ~isscalar(varargin{1}) || ~(mod(varargin{1},1)==0)...
                || varargin{1}<1 || varargin{1}>this.maxLevel)
                error('Input argument no. 1 must be a strictly positive integer smaller than %d.', this.maxLevel)
            elseif (~isa(varargin{2},'numeric') || ~isscalar(varargin{2}) || ...
                    ~(mod(varargin{2},1)==0) || varargin{2}<1 || varargin{2}>this.dim)
                error('Input argument no. 2 must be a strictly positive integer smaller than %d.', this.dim)
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('knots', this.objectHandle, varargin{:});
        end
        
        % active - call class method
        function [varargout] = active(this, varargin)
            %active - active functions of a gsTHBSplineBasis object
            %
            %Usage:
            %  act = thb.active( pts )
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %  pts: double, [d x numPts].
            %    Points in which to evaluate the function.
            %
            %Output:
            %  act: double, [numFun x numPts].
            %    Index of active functions in each of the specified points.
            
            if (nargin~=2 || nargout>1)
                error('Invalid number of input and/or output arguments.')
            end
            if (~isa(varargin{1},'numeric') || ~ismatrix(varargin{1}) || ~isequal(size(varargin{1},1),this.dim()))
                error('Input argument no. 1 must be numeric, 2-dimensional, and with d rows.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('active', this.objectHandle, varargin{:});
        end

        % uniformRefine - call class method
        function [varargout] = uniformRefine(this, varargin)
            %uniformRefine - proceed to a uniformRefinement of a gsTHBSplineBasis object
            %
            %Usage:
            %  thb.uniformRefine(numKnots, mult)
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %  numKnots: int, number of new knots inserted on each knot span.
            %  mult: int, each knot is inserted with a multiplicity mult.
            %
            %Output:
            %  None - changes done inline.

            if (nargin~=3 || nargout>0)
                error('Invalid number of input and/or output arguments.')
            end
            if (~isa(varargin{1},'numeric') || ~isscalar(varargin{1}) || ...
                ~(floor(varargin{1})==varargin{1}) || ~(varargin{1}>0) ||...
                ~isa(varargin{2},'numeric') || ~isscalar(varargin{2}) || ...
                ~(floor(varargin{2})==varargin{2}) || ~(varargin{2}>0))
                error('Input argument no. 1 and 2 must stricly positive integers.')
            end
            mex_gsTHBSplineBasis('uniformRefine', this.objectHandle, varargin{:});
        end

        % uniformRefine_withCoefs - call class method
        function [varargout] = uniformRefine_withCoefs(this, varargin)
            %uniformRefine_withCoefs - Refine the basis given by a gsTHBSplineBaiss 
            % object uniformly. The function simultainously updates the vector coefs,
            % representing a function in the bases, such that its new version 
            % represents the same function.
            %
            %Usage:
            %  thb.uniformRefine_withCoefs(coefs, numKnots, mult)
            %
            %Input:
            %  thb: gsTHBSplineBasis, [1 x 1].
            %    The gsTHBSplineBasis object.
            %  coefs: the coefficients representing a function in the bases 
            %    before the basis is refined.
            %  numKnots: int, number of new knots inserted on each knot span.
            %  mult: int, each knot is inserted with a multiplicity mult.
            %
            %Output:
            %  None - changes done inline.

            if (nargin~=4 || nargout~=1)
                error('Invalid number of input and/or output arguments.')
            end
            if (~isa(varargin{2},'numeric') || ~isscalar(varargin{2}) ||...
                ~(floor(varargin{2})==varargin{2}) || ~(varargin{2}>0) ||...
                ~isa(varargin{3},'numeric') || ~isscalar(varargin{3}) ||...
                ~(floor(varargin{3})==varargin{3}) || ~(varargin{3}>0) ||...
                ~isa(varargin{1},'numeric') || ~ismatrix(varargin{1}))
                error('Input argument no. 1 should be a 2d array of double, inputs no. 2 and 3 must' ...
                       + 'be stricly positive integers.')
            end
            [varargout{1:nargout}] = mex_gsTHBSplineBasis('uniformRefine_withCoefs', this.objectHandle,...
                                                           varargin{:});
        end

    end
end
