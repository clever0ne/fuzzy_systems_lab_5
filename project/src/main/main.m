clc; clear; close all;

n = 25;
x1min =  0;
x1max = pi;
x2min = -1;
x2max =  1;
ymin  =  0;
ymax  =  1;

x1 = linspace(x1min, x1max, n);
x2 = linspace(x2min, x2max, n);
x = reshape(cat(3, repmat(x1, length(x2), 1)', ...
                   repmat(x2, length(x1), 1)), [], 2, 1);

y = sin(x1 - 2 * x2').^2 .* exp(-abs(x2'));
print_surface_plot(x1, x2, y, 'Original Function', 'original_function.emf');

name = { 'negative-big', 'negative-middle', 'zero', 'positive-middle', 'positive-big' };
count = length(name);

fis1 = readfis('../model/mamdani_gaussmf_5in_gaussmf_5out.fis');
fis2 = mamfis('Name', 'mamdani_gaussmf_5in_gaussmf_5out_custom.fis');

input1 = fisvar([x1min, x1max], 'Name', 'x1');
dx1 = x1max - x1min;
for k = 1 : count
    params = [dx1 / (2 * count), x1min + dx1 * (k - 1) / (count - 1)];
    gaussmf = fismf('gaussmf', params, 'Name', name{k});
    input1.membershipFunctions(k) = gaussmf;
end

input2 = fisvar([x2min, x2max], 'Name', 'x2');
dx2 = x2max - x2min;
for k = 1 : length(name)
    params = [dx2 / (2 * count), x2min + dx2 * (k - 1) / (count - 1)];
    gaussmf = fismf('gaussmf', params, 'Name', name{k});
    input2.membershipFunctions(k) = gaussmf;
end

output = fisvar([ymin, ymax], 'Name', 'y');
dy = ymax - ymin;
for k = 1 : length(name)
    params = [dy / (2 * count), ymin + dy * (k - 1) / (count - 1)];
    gaussmf = fismf('gaussmf', params, 'Name', name{k});
    output.membershipFunctions(k) = gaussmf;
end

fis2.input(1) = input1;
fis2.input(2) = input2;
fis2.output   = output;

fis2.rules = [
    fisrule('x1 == zero            & x2 == zero            => y = positive-big'   ); 
    fisrule('x1 == negative-middle & x2 == negative-middle => y = zero'           ); 
    fisrule('x1 == positive-middle & x2 == positive-middle => y = zero'           ); 
    fisrule('x1 == negative-big    & x2 == positive-big    => y = zero'           ); 
    fisrule('x1 == positive-big    & x2 == negative-big    => y = zero'           ); 
    fisrule('x1 == negative-big    & x2 == negative-big    => y = negative-middle'); 
    fisrule('x1 == positive-big    & x2 == positive-big    => y = negative-middle'); 
    fisrule('x1 == negative-middle & x2 == positive-middle => y = negative-big'   ); 
    fisrule('x1 == positive-middle & x2 == negative-middle => y = negative-big'   ); 
    fisrule('x1 == zero            & x2 == negative-big    => y = negative-big'   ); 
    fisrule('x1 == zero            & x2 == positive-big    => y = negative-big'   ); 
    fisrule('x1 == negative-big    & x2 == zero            => y = negative-big'   ); 
    fisrule('x1 == positive-big    & x2 == zero            => y = negative-big'   );
];

y1 = reshape(evalfis(fis1, x), length(x1), length(x2))';
rmse1 = sqrt(sum(sum((y - y1).^2)) / numel(y1));
print_surface_plot(x1, x2, y1, 'Default Mamdani Gauss MF Surface', ...
                   'mamdani_gauss_5in_gauss_5out_surface_default.emf', rmse1);

y2 = reshape(evalfis(fis2, x), length(x1), length(x2))';
rmse2 = sqrt(sum(sum((y - y2).^2)) / numel(y2));
print_surface_plot(x1, x2, y2, 'Custom Mamdani Gauss MF Surface', ...
                   'mamdani_gauss_5in_gauss_5out_surface_custom.emf', rmse2);

writefis(fis2, strcat('../model/', fis2.name));
fprintf('dy_max = %.4g\n', max(max(y2 - y1)));

print_surface_plot(x1, x2, y1, '', 'mamdani_5in_5out_surface.emf', rmse1);
print_membership_functions_plot('x_1', x1, 5, 'gaussmf', 'Gauss MF', 'x1_5in.emf');
print_membership_functions_plot('x_2', x2, 5, 'gaussmf', 'Gauss MF', 'x2_5in.emf');
print_membership_functions_plot('y',    y, 5, 'gaussmf', 'Gauss MF', 'y_5out.emf');
