## -*- encoding: utf-8 -*-
## This file (SagemathGraphExample.sagetex.sage) was *autogenerated* from SagemathGraphExample.tex with sagetex.sty version 2015/08/26 v3.0-92d9f7a.
import sagetex
_st_ = sagetex.SageTeXProcessor('SagemathGraphExample', version='2015/08/26 v3.0-92d9f7a', version_check=True)
_st_.current_tex_line = 7
_st_.blockbegin()
try:
 k = 2
 G=Graph({0: {1: '01', 2: '02', 3: '03'}, 1: {4: '14', 5: '15'}, 2: {6: '26', 4: '24'}, 3: {5: '35', 6: '36'}, 4: {7: '47'}, 5: {7: '57'}, 6: {7: '67'} }); graph_name='Q3' # Cube with natural notation
 v = G.order()
 e = G.size()
 show(G,figsize=[3,3])
 G.show(title=graph_name,graph_border=True,edge_labels=True,figsize=[3,3])
 b = e-v+1
 print 'k =', k
 print graph_name, 'has e =',e,', v =', v, 'and b =', b
 
 
 E = e*binomial(k+v-2,k-1) # note v-1=e since beta=0 for T
 V = binomial(k+v-1,k)
 beta = E-V+1;
 R = PolynomialRing(ZZ,v,'a') # Ring of vertices of G^(k) as monomials with indeterminants associated to vertices of T/G (note V[T]=V(G))
 R.inject_variables(verbose=false)
 av = sum([ R.gen(i) for i in range(v) ])
 f = av^k; f1 = av^(k-1); # f2 = av^(k-2);
 F = f.monomials(); F1 = f1.monomials(); # F2 = f2.monomials()
 #shortprint(F,'F ='); shortprint(F1,'F1 ='); # shortprint(F2,'F2 =')
 dF = dict((F[i],i) for i in range(len(F))) # dictionary of monomials in Mk
 dF1 = dict((F1[i],i) for i in range(len(F1))) # dictionary of monomials in Mk-1
 Gk=Graph(vertex_labels=true)
 for f in F:
     Gk.add_vertex(name=f)
     #print G.edges()
     print
     for edge in G.edges(): # every edge of G
         for jmk1 in F1: # every F1
             vm,vp,lab = edge
             x = jmk1*R.gen(vm)
             y = jmk1*R.gen(vp)
             Gk.add_edge(x,y,edge[2])
 H=Gk
 H.set_latex_options(scale=4,graphic_size=(3.1,3.1))
except:
 _st_.goboom(43)
_st_.blockend()
try:
 _st_.current_tex_line = 50
 _st_.inline(0, latex(H))
except:
 _st_.goboom(50)
