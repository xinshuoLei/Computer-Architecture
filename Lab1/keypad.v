module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output   [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire     wad, wae, waf, wbd, wbe, wbf, wcd, wce, wcf, wbg,
            wabc, wdef, w1;
   and  a1(wad, a, d);
   and  a2(wae, a, e);
   and  a3(waf, a, f);
   and  a4(wbd, b, d);
   and  a5(wbe, b, e);
   and  a6(wbf, b, f);
   and  a7(wcd, c, d);
   and  a8(wce, c, e);
   and  a9(wcf, c, f);
   and  a10(wbg, b ,g);
   or   o1(wabc, a, b, c);
   or   o2(wdef, d, e, f);
   and  a11(w1, wabc, wdef);
   or   o3(valid, wbg, w1);
   or   o4(number[0], wad, wcd, wbe, waf, wcf);
   or   o5(number[1], wbd, wcd, wce, waf);
   or   o6(number[2], e, waf);
   or   o7(number[3], wbf, wcf);
endmodule // keypad
