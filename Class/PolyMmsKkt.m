classdef PolyMmsKkt < handle
    % use degration of acceleration to get a estimation of deformation
    % turn data in time domain to the space domain

    properties
        xx_itg;
        dx;
        p_x;
        p_y;
        m;
        coe_a;
        coe_itg1;
        w;
        b;
        n_dr;
        n_itg;
        itg_true;
        n_deritg;
        
    end

    methods
        function obj = PolyMmsKkt(p_x, p_y, m, varargin)


        % able to add derivative informations
        % length of p_x and p_y should be the same
        % edit on 2022/11/03
        
        % derive: [x, derive_x]
        % [0, 0; 5.4, 0]


        
            if length(p_x) ~= length(p_y)
                obj.coe_a = 0;
                disp("Error: nonsingular matrix ! Please check the amount of x and y.");
                return;
            end
            
        
            p = inputParser;
            validScalarPosNum = @(a) isnumeric(a);
%             addRequired(p,'obj',validScalarPosNum);
            addRequired(p,'p_x',validScalarPosNum);
            addRequired(p,'p_y',validScalarPosNum);
            addRequired(p,'m',validScalarPosNum);
            addOptional(p,'derive', 'NULL', validScalarPosNum);
            addOptional(p,'integrade', 'NULL', validScalarPosNum);
        
            parse(p, p_x, p_y, m, varargin{:});

            obj.m = p.Results.m;
            
            % KKT method
            [obj.w, obj.b] = gererate_wb(p.Results.p_x, p.Results.p_y, obj.m);


            % initial number of derivative condition
            obj.n_dr = get_n_dr(p.Results.derive);

            % initial number of integrade condition
            % bug
            [obj.n_itg, obj.itg_true] = get_n_itg(p.Results.integrade);

            obj.n_deritg = obj.n_dr + obj.n_itg;

            n_xy = obj.m + 1 - obj.n_deritg;

            [c, d] = generate_cd(m,p.Results.derive,p.Results.integrade);
            [W,B] = get_all(obj.w,obj.b,c,d);
            temp_a = inv(W) * B;
            obj.coe_a = temp_a(1:m+1);
        


            % save integrade function
            itg1 = zeros(obj.m+1,1);
            for i = 1:1:obj.m+1
                itg1(i) = obj.coe_a(i)/i;
            end
            obj.coe_itg1 = itg1;

        end


        function [yy, itg_yy] = view_spline(obj, xx, dx)
            % yy: rotation
            % yy_itg: deformation
            obj.xx_itg = xx;
            obj.dx = dx;
            yy = zeros(length(xx), 1);
            itg_yy = zeros(length(xx), 1);
            for i = 1:1:length(xx)
                for j = 1:1:obj.m + 1
                    yy(i) = yy(i) + obj.coe_a(j)*xx(i)^(j-1);
                    itg_yy(i) = itg_yy(i) + obj.coe_itg1(j)*xx(i)^j;
                end
            end

        end


        function locate_y = find_location(obj, x_rot, index_y)
            % find values from index_y at location x_rot
            % distance of index_y is given by obj.dx

            locate_y = zeros(1,length(x_rot));
            for i = 1:1:length(x_rot)
                i_y = 1 + round(x_rot(i) / obj.dx);
                locate_y(i) = index_y(i_y);
            end

        end


        function auto_plot(obj, xx, varargin)

            if nargin == 4
                figure(varargin{end})
                hold on
                scatter(obj.p_x, obj.p_y)
                plot(xx, varargin{1});
                legend("original", "fit")
            elseif nargin == 5
%                 figure(varargin{end})
                hold on
                plot(obj.p_x, obj.p_y, 'o')
                plot(xx, varargin{1});
                plot(xx, varargin{2});
                plot(xx, zeros(length(xx),1))
                legend("original", "rotaion angle", "deformation", 'location','northwest')
            end

        end


    end
end
