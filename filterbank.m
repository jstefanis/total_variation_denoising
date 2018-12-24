function res=filterbank(s,l,h0,sens);

res=[];

for n=0:length(h0)-1,
   g0(n+1)=h0(n+1)*(-1)^(n+1);
end;
g0=g0(length(g0):-1:1);

for n=0:length(g0)-1,
   h1(n+1)=g0(n+1)*(-1)^(n);
end;
for n=0:length(h0)-1,
   g1(n+1)=h0(n+1)*(-1)^(n);
end;
g1=g1*(-1);


if sens==0,
	trame=s;
   for b=1:l,
      n=length(trame);

		s2=pconv(h0,trame);
		S2=s2(1:2:n);
      
      s3=pconv(g0,trame);
		S3=s3(1:2:n);
      
      res=[S3 res];
      trame=S2;
   end;
   res=[trame res];
else
   trame=s(1:length(s)/2^l);
   %Calcul du décalage dans le temps
   %calcul du produit entre les filtres H0(z)H1(z)+G0(z)G1(z)
   dec=round(conv(h0,h1)+conv(g0,g1))
   ind_dec=find(abs(dec)>0)-1
   signe=sign(dec(ind_dec+1));
  for b=1:l,

   n=length(trame);   
   s2p=zeros(1,n*2);
	s2p(1:2:n*2)=trame;
	S2p=pconv(h1,s2p);

	s3p=zeros(1,n*2);
	s3p(1:2:2*n)=s(n+1:2*n);
	S3p=pconv(g1,s3p);

	rec=S2p+S3p;
   
   %recalage dans le temps
   if ind_dec>0
      rec=[rec(ind_dec+1:length(rec)) rec(1:ind_dec)];
   end;
   
   trame=rec*signe;
end;
res=trame;
end;
