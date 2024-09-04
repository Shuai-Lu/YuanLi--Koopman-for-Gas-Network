function y = func_observable_generator(x, type)
switch type
    case 'linear'
        y = x;

    case 'quadratic'
        y = x.^2;

    case 'cubic'
        y = x.^3;

    case 'fourth'
        y = x.^4;

    case 'fifth'
        y = x.^5;

    case 'sixth'
        y = x.^6;

    case 'inverse'
        y = 1 ./ (1 + x);

    case 'log'
        y = log(1 + x);

    case 'exp'
        y = exp(x);

    case 'xexp'
        y = x .* exp(x);

    case 'sin'
        y = sin(x);
    case 'cos'
        y = cos(x);

    case 'expsin'
        y = exp(x).*sin(x);
    case 'expcos'
        y = exp(x).*cos(x);

    case 'xsin'
        y = x.*sin(x);
    case 'xcos'
        y = x.*cos(x);

    case 'radialbasis1'
        y = x .^ log(x);

    case 'radialbasis2'
        y = x.^2 .^ log(x);       

    case 'hermite'
        y = hermiteH(x);

    case 'inverse*e^x'
        y = 3*x  ./ (1 + x);

end