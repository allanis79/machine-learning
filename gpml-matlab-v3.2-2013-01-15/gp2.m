function [ymu ys2 fmu fs2 ] = gp2(hyp, inf, mean, cov, lik, x, y, xs)
function [post] = infExact(hyp, mean, cov, lik, x, y)
alpha = post.alpha; L = post.L; sW = post.sW;
ns = size(xs,1);                                       % number of data points
  nperbatch = 1000;                       % number of data points per mini batch
  nact = 0;                       % number of already processed test data points
  ymu = zeros(ns,1); ys2 = ymu; fmu = ymu; fs2 = ymu; lp = ymu;   % allocate mem
  while nact<ns               % process minibatches of test cases to save memory
    id = (nact+1):min(nact+nperbatch,ns);               % data points to process
    kss = feval(cov{:}, hyp.cov, xs(id,:), 'diag');              % self-variance
    Ks  = feval(cov{:}, hyp.cov, x(nz,:), xs(id,:));         % cross-covariances
    ms = feval(mean{:}, hyp.mean, xs(id,:));
    N = size(alpha,2);  % number of alphas (usually 1; more in case of sampling)
    Fmu = repmat(ms,1,N) + Ks'*full(alpha(nz,:));        % conditional mean fs|f
    fmu(id) = sum(Fmu,2)/N;                                   % predictive means
    if Ltril           % L is triangular => use Cholesky parameters (alpha,sW,L)
      V  = L'\(repmat(sW,1,length(id)).*Ks);
      fs2(id) = kss - sum(V.*V,1)';                       % predictive variances
    else                % L is not triangular => use alternative parametrisation
      fs2(id) = kss + sum(Ks.*(L*Ks),1)';                 % predictive variances
    end
    fs2(id) = max(fs2(id),0);   % remove numerical noise i.e. negative variances
    Fs2 = repmat(fs2(id),1,N);     % we have multiple values in case of sampling
    if nargin<9
      [Lp, Ymu, Ys2] = feval(lik{:},hyp.lik,[],Fmu(:),Fs2(:));
    else
      [Lp, Ymu, Ys2] = feval(lik{:},hyp.lik,repmat(ys(id),1,N),Fmu(:),Fs2(:));
    end
    lp(id)  = sum(reshape(Lp, [],N),2)/N;    % log probability; sample averaging
    ymu(id) = sum(reshape(Ymu,[],N),2)/N;          % predictive mean ys|y and ..
    ys2(id) = sum(reshape(Ys2,[],N),2)/N;                          % .. variance
    nact = id(end);          % set counter to index of last processed data point
  end
  if nargin<9
    varargout = {ymu, ys2, fmu, fs2, [], post};        % assign output arguments
  else
    varargout = {ymu, ys2, fmu, fs2, lp, post};
  end
end
end

