/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : X-2025.06
// Date      : Tue Sep 22 13:50:40 2026
/////////////////////////////////////////////////////////////


module gcd_DW_mult_uns_2 ( a, b, product_19_, product_18_, product_17_, 
        product_16_, product_15_, product_14_, product_13_, product_12_, 
        product_11_, product_10_, product_9_, product_8_, product_7_, 
        product_6_, product_5_, product_4_, product_3_, product_2_, product_0_
 );
  input [9:0] a;
  input [9:0] b;
  output product_19_, product_18_, product_17_, product_16_, product_15_,
         product_14_, product_13_, product_12_, product_11_, product_10_,
         product_9_, product_8_, product_7_, product_6_, product_5_,
         product_4_, product_3_, product_2_, product_0_;
  wire   n1, n2, n4, n5, n7, n8, n9, n11, n12, n13, n14, n15, n20, n21, n25,
         n26, n28, n30, n31, n32, n33, n34, n35, n36, n37, n39, n41, n42, n43,
         n44, n45, n46, n49, n51, n52, n53, n54, n55, n56, n57, n58, n62, n63,
         n64, n65, n66, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n80, n81, n82, n83, n84, n85, n86, n87, n88, n90, n92, n93, n95, n97,
         n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109,
         n110, n111, n115, n116, n119, n128, n131, n136, n137, n138, n139,
         n140, n141, n142, n143, n144, n145, n146, n147, n148, n149, n150,
         n151, n152, n153, n154, n155, n156, n157, n158, n159, n160, n161,
         n162, n163, n164, n165, n166, n167, n168, n169, n170, n171, n173,
         n174, n175, n176, n177, n178, n179, n180, n181, n182, n183, n184,
         n185, n186, n187, n188, n189, n190, n191, n192, n193, n194, n195,
         n196, n197, n198, n199, n200, n201, n202, n203, n205, n206, n207,
         n208, n211, n212, n214, n215, n216, n217, n218, n219, n220, n221,
         n222, n223, n224, n225, n226, n227, n228, n229, n230, n231, n232,
         n233, n234, n236, n245, n246, n247, n248, n249, n250, n251, n252,
         n253, n254, n288, n289, n290, n292, n293, n294, n295, n296, n297,
         n298, n299, n301, n302, n303, n304, n305, n306, n307, n308, n309,
         n310, n311, n312, n313, n314, n315, n316, n317, n318, n319, n321,
         n322, n323, n324, n325, n326, n327, n329, n330, n331, n332, n333;

  ADDFHX4 U159 ( .A(n307), .B(n293), .CI(n197), .CO(n146), .S(n147) );
  XNOR2X2 U248 ( .A(n42), .B(n317), .Y(product_16_) );
  NAND2X2 U249 ( .A(n155), .B(n160), .Y(n81) );
  NOR2X8 U250 ( .A(n155), .B(n160), .Y(n80) );
  AOI21X2 U251 ( .A0(n310), .A1(n321), .B0(n39), .Y(n37) );
  INVX1 U252 ( .A(n86), .Y(n85) );
  NOR2X6 U253 ( .A(n299), .B(n245), .Y(n215) );
  INVX6 U254 ( .A(b[0]), .Y(n245) );
  XOR2X8 U255 ( .A(n62), .B(n5), .Y(product_14_) );
  NAND3X4 U256 ( .A(n312), .B(n313), .C(n314), .Y(n160) );
  NAND2X4 U257 ( .A(n161), .B(n168), .Y(n84) );
  INVX6 U258 ( .A(b[5]), .Y(n250) );
  NOR2X3 U259 ( .A(n253), .B(n249), .Y(n219) );
  INVX10 U260 ( .A(b[6]), .Y(n249) );
  ADDFHX4 U261 ( .A(n215), .B(n227), .CI(n224), .CO(n176), .S(n177) );
  XOR2X8 U262 ( .A(n26), .B(n1), .Y(product_18_) );
  OAI21X4 U263 ( .A0(n87), .A1(n296), .B0(n88), .Y(n86) );
  ADDFX1 U264 ( .A(a[8]), .B(n201), .CI(n194), .CO(n136), .S(n137) );
  AOI21X6 U265 ( .A0(n86), .A1(n78), .B0(n79), .Y(n77) );
  NOR2X2 U266 ( .A(n181), .B(n184), .Y(n102) );
  NOR2X2 U267 ( .A(n189), .B(n190), .Y(n109) );
  INVX4 U268 ( .A(b[4]), .Y(n251) );
  NOR2X2 U269 ( .A(n181), .B(n184), .Y(n315) );
  INVX2 U270 ( .A(b[2]), .Y(n253) );
  OR2X2 U271 ( .A(n249), .B(n248), .Y(n288) );
  NAND2X1 U272 ( .A(n163), .B(n165), .Y(n314) );
  ADDFHX4 U273 ( .A(a[7]), .B(n309), .CI(n196), .CO(n142), .S(n143) );
  CLKINVX8 U274 ( .A(n288), .Y(n309) );
  XOR2X2 U275 ( .A(n13), .B(n107), .Y(product_6_) );
  NOR2XL U276 ( .A(n250), .B(n247), .Y(n203) );
  NOR2XL U277 ( .A(n246), .B(n250), .Y(n195) );
  NOR2XL U278 ( .A(n253), .B(n250), .Y(n224) );
  NOR2X4 U279 ( .A(n245), .B(n250), .Y(n226) );
  NOR2X6 U280 ( .A(n251), .B(n250), .Y(n222) );
  AOI21X6 U281 ( .A0(n330), .A1(n95), .B0(n90), .Y(n88) );
  AOI21X6 U282 ( .A0(n98), .A1(n329), .B0(n95), .Y(n93) );
  ADDHX4 U283 ( .A(a[5]), .B(n218), .CO(n166), .S(n167) );
  NOR2X6 U284 ( .A(n297), .B(n298), .Y(n214) );
  AOI21X4 U285 ( .A0(n64), .A1(n34), .B0(n35), .Y(n33) );
  INVX4 U286 ( .A(b[8]), .Y(n247) );
  OR2X4 U287 ( .A(n253), .B(n298), .Y(n289) );
  NOR2X2 U288 ( .A(n246), .B(n253), .Y(n198) );
  NAND2X3 U289 ( .A(n149), .B(n154), .Y(n75) );
  OAI21X4 U290 ( .A0(n69), .A1(n75), .B0(n70), .Y(n64) );
  NOR2X2 U291 ( .A(n74), .B(n69), .Y(n63) );
  INVX4 U292 ( .A(n64), .Y(n66) );
  XOR2X2 U293 ( .A(n53), .B(n4), .Y(product_15_) );
  ADDHX1 U294 ( .A(n230), .B(n232), .CO(n188), .S(n189) );
  INVX2 U295 ( .A(n108), .Y(n107) );
  OAI21X6 U296 ( .A0(n111), .A1(n109), .B0(n110), .Y(n108) );
  INVX2 U297 ( .A(n289), .Y(n308) );
  NOR2X4 U298 ( .A(n144), .B(n141), .Y(n56) );
  ADDFX1 U299 ( .A(n202), .B(n195), .CI(n142), .CO(n138), .S(n139) );
  OR2X2 U300 ( .A(n138), .B(n137), .Y(n321) );
  NAND2X2 U301 ( .A(n303), .B(n304), .Y(product_13_) );
  CLKINVX2 U302 ( .A(n326), .Y(n302) );
  ADDHX1 U303 ( .A(a[2]), .B(n233), .CO(n190), .S(n191) );
  INVX4 U304 ( .A(b[7]), .Y(n299) );
  NOR2X2 U305 ( .A(n185), .B(n188), .Y(n105) );
  INVX2 U306 ( .A(n207), .Y(n305) );
  INVX4 U307 ( .A(b[3]), .Y(n252) );
  INVX2 U308 ( .A(n97), .Y(n95) );
  NOR2X2 U309 ( .A(n148), .B(n145), .Y(n69) );
  ADDFHX2 U310 ( .A(n152), .B(n147), .CI(n150), .CO(n144), .S(n145) );
  AND2X2 U311 ( .A(n316), .B(n70), .Y(n326) );
  NOR2X2 U312 ( .A(n36), .B(n56), .Y(n34) );
  NAND2X2 U313 ( .A(n49), .B(n321), .Y(n36) );
  NOR2X2 U314 ( .A(n65), .B(n45), .Y(n43) );
  NOR2X1 U315 ( .A(n246), .B(n245), .Y(n200) );
  INVX2 U316 ( .A(b[9]), .Y(n246) );
  OR2X2 U317 ( .A(n250), .B(n248), .Y(n290) );
  INVX2 U318 ( .A(b[1]), .Y(n254) );
  AND2X2 U319 ( .A(n294), .B(n119), .Y(product_2_) );
  AND2X2 U320 ( .A(n223), .B(n208), .Y(n292) );
  NOR2X2 U321 ( .A(n252), .B(n298), .Y(n212) );
  NOR2X2 U322 ( .A(n297), .B(n251), .Y(n229) );
  NOR2X2 U323 ( .A(n251), .B(n247), .Y(n293) );
  OR2X2 U324 ( .A(n236), .B(a[1]), .Y(n294) );
  INVX2 U325 ( .A(n92), .Y(n90) );
  XNOR2X1 U326 ( .A(n104), .B(n12), .Y(product_7_) );
  AND2X1 U327 ( .A(a[3]), .B(a[0]), .Y(n233) );
  OR2XL U328 ( .A(n155), .B(n160), .Y(n295) );
  OAI21X1 U329 ( .A0(n85), .A1(n83), .B0(n84), .Y(n82) );
  ADDFHX2 U330 ( .A(n217), .B(n206), .CI(n199), .CO(n158), .S(n159) );
  NAND2XL U331 ( .A(n128), .B(n84), .Y(n9) );
  NOR2BX4 U332 ( .AN(n330), .B(n90), .Y(n319) );
  CLKNAND2X2 U333 ( .A(n174), .B(n169), .Y(n92) );
  INVX4 U334 ( .A(n99), .Y(n98) );
  OR2X6 U335 ( .A(n169), .B(n174), .Y(n330) );
  AOI21X2 U336 ( .A0(n100), .A1(n108), .B0(n101), .Y(n296) );
  AOI21X6 U337 ( .A0(n100), .A1(n108), .B0(n101), .Y(n99) );
  NOR2X3 U338 ( .A(n102), .B(n105), .Y(n100) );
  OR2X4 U339 ( .A(n32), .B(n77), .Y(n318) );
  INVX2 U340 ( .A(b[1]), .Y(n297) );
  INVX3 U341 ( .A(b[7]), .Y(n298) );
  INVX2 U342 ( .A(b[7]), .Y(n248) );
  INVXL U343 ( .A(n245), .Y(product_0_) );
  ADDHX2 U344 ( .A(a[4]), .B(n220), .CO(n178), .S(n179) );
  INVX4 U345 ( .A(n51), .Y(n49) );
  NAND2X2 U346 ( .A(n63), .B(n34), .Y(n32) );
  AOI21X4 U347 ( .A0(n76), .A1(n72), .B0(n73), .Y(n71) );
  INVX4 U348 ( .A(n77), .Y(n76) );
  NAND2X1 U349 ( .A(n144), .B(n141), .Y(n57) );
  NAND2X1 U350 ( .A(n184), .B(n181), .Y(n103) );
  NOR2X4 U351 ( .A(n80), .B(n83), .Y(n78) );
  NOR2XL U352 ( .A(n254), .B(n246), .Y(n199) );
  NOR2X2 U353 ( .A(n254), .B(n247), .Y(n207) );
  INVX2 U354 ( .A(n71), .Y(n301) );
  NAND2X2 U355 ( .A(n71), .B(n326), .Y(n303) );
  CLKNAND2X2 U356 ( .A(n301), .B(n302), .Y(n304) );
  OAI21X1 U357 ( .A0(n66), .A1(n45), .B0(n46), .Y(n44) );
  NAND2X1 U358 ( .A(n58), .B(n49), .Y(n45) );
  AOI21X1 U359 ( .A0(n76), .A1(n54), .B0(n55), .Y(n53) );
  AOI21X1 U360 ( .A0(n76), .A1(n43), .B0(n44), .Y(n42) );
  XOR2X2 U361 ( .A(n223), .B(n208), .Y(n173) );
  NOR2X1 U362 ( .A(n247), .B(n245), .Y(n208) );
  NAND2X8 U363 ( .A(n318), .B(n33), .Y(n31) );
  NAND2X2 U364 ( .A(n330), .B(n331), .Y(n87) );
  NOR2X4 U365 ( .A(n252), .B(n251), .Y(n227) );
  OR2X1 U366 ( .A(n253), .B(n245), .Y(n324) );
  NOR2X2 U367 ( .A(n252), .B(n249), .Y(n218) );
  NOR2XL U368 ( .A(n246), .B(n249), .Y(n194) );
  NOR2XL U369 ( .A(n249), .B(n247), .Y(n202) );
  OAI21X1 U370 ( .A0(n107), .A1(n105), .B0(n106), .Y(n104) );
  ADDFHX4 U371 ( .A(n219), .B(n214), .CI(n178), .CO(n170), .S(n171) );
  NOR2X4 U372 ( .A(n249), .B(n245), .Y(n221) );
  XOR2X8 U373 ( .A(n170), .B(n311), .Y(n161) );
  XOR2X8 U374 ( .A(n163), .B(n165), .Y(n311) );
  OR2X4 U375 ( .A(n191), .B(n234), .Y(n323) );
  NOR2X4 U376 ( .A(n250), .B(n249), .Y(n216) );
  NAND2BX4 U377 ( .AN(n175), .B(n332), .Y(n329) );
  NOR2X2 U378 ( .A(n254), .B(n249), .Y(n220) );
  CLKINVX8 U379 ( .A(n305), .Y(n306) );
  ADDFHX4 U380 ( .A(n222), .B(n306), .CI(n200), .CO(n164), .S(n165) );
  AOI21X8 U381 ( .A0(n31), .A1(n322), .B0(n28), .Y(n26) );
  NOR2XL U382 ( .A(n297), .B(n245), .Y(n236) );
  NOR2XL U383 ( .A(n251), .B(n245), .Y(n230) );
  NAND2XL U384 ( .A(n131), .B(n103), .Y(n12) );
  NAND2XL U385 ( .A(n329), .B(n97), .Y(n11) );
  NOR2X4 U386 ( .A(n161), .B(n168), .Y(n83) );
  CLKINVX4 U387 ( .A(n290), .Y(n307) );
  NOR2X1 U388 ( .A(n253), .B(n252), .Y(n231) );
  ADDFHX4 U389 ( .A(n167), .B(n308), .CI(n292), .CO(n162), .S(n163) );
  ADDFHX4 U390 ( .A(n212), .B(n166), .CI(n164), .CO(n156), .S(n157) );
  ADDFHX2 U391 ( .A(n211), .B(n205), .CI(n153), .CO(n150), .S(n151) );
  ADDFHX2 U392 ( .A(a[6]), .B(n216), .CI(n198), .CO(n152), .S(n153) );
  XNOR2X4 U393 ( .A(n31), .B(n2), .Y(product_17_) );
  AOI21BX4 U394 ( .A0(n323), .A1(n116), .B0N(n115), .Y(n111) );
  NOR2X1 U395 ( .A(n246), .B(n251), .Y(n196) );
  NOR2XL U396 ( .A(n246), .B(n252), .Y(n197) );
  OAI21X4 U397 ( .A0(n80), .A1(n84), .B0(n81), .Y(n79) );
  XNOR2X4 U398 ( .A(n82), .B(n8), .Y(product_11_) );
  ADDHX2 U399 ( .A(n221), .B(n225), .CO(n182), .S(n183) );
  ADDFHX4 U400 ( .A(n173), .B(n176), .CI(n171), .CO(n168), .S(n169) );
  ADDHX2 U401 ( .A(a[3]), .B(n226), .CO(n186), .S(n187) );
  NOR2X1 U402 ( .A(n252), .B(n247), .Y(n205) );
  NOR2X1 U403 ( .A(n253), .B(n247), .Y(n206) );
  ADDFHX2 U404 ( .A(n228), .B(n186), .CI(n183), .CO(n180), .S(n181) );
  ADDFHX4 U405 ( .A(n159), .B(n162), .CI(n157), .CO(n154), .S(n155) );
  ADDFHX2 U406 ( .A(n231), .B(n229), .CI(n187), .CO(n184), .S(n185) );
  ADDFHX2 U407 ( .A(n158), .B(n156), .CI(n151), .CO(n148), .S(n149) );
  NOR2X2 U408 ( .A(n253), .B(n251), .Y(n228) );
  NOR2X1 U409 ( .A(n251), .B(n249), .Y(n217) );
  CLKAND2X4 U410 ( .A(n140), .B(n139), .Y(n310) );
  ADDFHX2 U411 ( .A(n203), .B(n143), .CI(n146), .CO(n140), .S(n141) );
  NAND2XL U412 ( .A(n170), .B(n163), .Y(n312) );
  NAND2XL U413 ( .A(n170), .B(n165), .Y(n313) );
  NOR2XL U414 ( .A(n298), .B(n247), .Y(n201) );
  NOR2X1 U415 ( .A(n297), .B(n250), .Y(n225) );
  INVXL U416 ( .A(n56), .Y(n58) );
  NAND2XL U417 ( .A(n322), .B(n325), .Y(n20) );
  OR2XL U418 ( .A(n148), .B(n145), .Y(n316) );
  AND2XL U419 ( .A(n321), .B(n41), .Y(n317) );
  OAI2B1XL U420 ( .A1N(n31), .A0(n20), .B0(n21), .Y(product_19_) );
  OAI21X2 U421 ( .A0(n36), .A1(n57), .B0(n37), .Y(n35) );
  NAND2XL U422 ( .A(n140), .B(n139), .Y(n52) );
  NAND2XL U423 ( .A(n72), .B(n75), .Y(n7) );
  AOI2B1X2 U424 ( .A1N(n57), .A0(n49), .B0(n310), .Y(n46) );
  XNOR2XL U425 ( .A(n15), .B(n116), .Y(product_4_) );
  XOR2XL U426 ( .A(n111), .B(n14), .Y(product_5_) );
  NAND2BX1 U427 ( .AN(n109), .B(n110), .Y(n14) );
  NAND2XL U428 ( .A(n138), .B(n137), .Y(n41) );
  XOR2XL U429 ( .A(n324), .B(n119), .Y(product_3_) );
  NOR2XL U430 ( .A(n251), .B(n248), .Y(n211) );
  NOR2XL U431 ( .A(n297), .B(n252), .Y(n232) );
  NAND2XL U432 ( .A(n191), .B(n234), .Y(n115) );
  NOR2XL U433 ( .A(n297), .B(n253), .Y(n234) );
  NOR2XL U434 ( .A(n246), .B(n248), .Y(n193) );
  INVX2 U435 ( .A(n63), .Y(n65) );
  INVXL U436 ( .A(n74), .Y(n72) );
  XNOR2X4 U437 ( .A(n93), .B(n319), .Y(product_9_) );
  NAND2X2 U438 ( .A(n49), .B(n52), .Y(n4) );
  NOR2XL U439 ( .A(n65), .B(n56), .Y(n54) );
  NAND2X2 U440 ( .A(n58), .B(n57), .Y(n5) );
  INVX2 U441 ( .A(n41), .Y(n39) );
  NAND2X2 U442 ( .A(n322), .B(n30), .Y(n2) );
  INVX2 U443 ( .A(n30), .Y(n28) );
  NAND2X2 U444 ( .A(n325), .B(n25), .Y(n1) );
  NOR2X2 U445 ( .A(n140), .B(n139), .Y(n51) );
  NOR2X2 U446 ( .A(n119), .B(n324), .Y(n116) );
  NAND2X2 U447 ( .A(n185), .B(n188), .Y(n106) );
  INVX2 U448 ( .A(n180), .Y(n332) );
  OR2X2 U449 ( .A(n136), .B(n193), .Y(n322) );
  AOI21BX2 U450 ( .A0(n28), .A1(n325), .B0N(n25), .Y(n21) );
  NAND2X2 U451 ( .A(n136), .B(n193), .Y(n30) );
  NAND2X2 U452 ( .A(n236), .B(a[1]), .Y(n119) );
  ADDFHX2 U453 ( .A(n179), .B(n182), .CI(n177), .CO(n174), .S(n175) );
  NAND2X2 U454 ( .A(n180), .B(n333), .Y(n97) );
  OR2X2 U455 ( .A(n192), .B(a[9]), .Y(n325) );
  NOR2XL U456 ( .A(n246), .B(n247), .Y(n192) );
  NAND2X2 U457 ( .A(n192), .B(a[9]), .Y(n25) );
  INVX2 U458 ( .A(n83), .Y(n128) );
  NAND2X1 U459 ( .A(n327), .B(n106), .Y(n13) );
  NOR2X2 U460 ( .A(n149), .B(n154), .Y(n74) );
  OAI21X1 U461 ( .A0(n66), .A1(n56), .B0(n57), .Y(n55) );
  NAND2XL U462 ( .A(n323), .B(n115), .Y(n15) );
  XNOR2XL U463 ( .A(n76), .B(n7), .Y(product_12_) );
  OR2XL U464 ( .A(n185), .B(n188), .Y(n327) );
  INVXL U465 ( .A(n102), .Y(n131) );
  NAND2X2 U466 ( .A(n189), .B(n190), .Y(n110) );
  XOR2X1 U467 ( .A(n85), .B(n9), .Y(product_10_) );
  CLKINVX2 U468 ( .A(n75), .Y(n73) );
  CLKNAND2X2 U469 ( .A(n148), .B(n145), .Y(n70) );
  OA21X4 U470 ( .A0(n77), .A1(n65), .B0(n66), .Y(n62) );
  NAND2X1 U471 ( .A(n295), .B(n81), .Y(n8) );
  NAND2BX2 U472 ( .AN(n175), .B(n332), .Y(n331) );
  XNOR2XL U473 ( .A(n98), .B(n11), .Y(product_8_) );
  XOR3X2 U474 ( .A(n179), .B(n182), .C(n177), .Y(n333) );
  NOR2X1 U475 ( .A(n252), .B(n250), .Y(n223) );
  OAI21X4 U476 ( .A0(n315), .A1(n106), .B0(n103), .Y(n101) );
endmodule


module gcd ( sqr_out, out_valid, clk, rst_n, data_in, in_valid );
  output [9:0] sqr_out;
  input [9:0] data_in;
  input clk, rst_n, in_valid;
  output out_valid;
  wire   n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n129, n130, n131, n132,
         n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, n143,
         n144, n145, n146, n147, n148, n149, n150, n151, n152, n153, n154,
         n155, n156, n157, n158, n159, n160, n161, n162, n163, n164, n165,
         n166, n167, n168, n169, n170, n171, n172, n173, n174, n175, n176,
         n177, n178, n179, n180, n181, n182, n183, n184, n185, n186, n187,
         n188, n189, n190, n191, n192, n193, n194, n195, n196, n197, n198,
         n199, n200;
  wire   [9:0] data_reg;
  wire   [1:0] state;
  wire   [3:0] bit_index;
  wire   [19:0] trial_square;
  wire   [8:0] trial_y;

  DFFRHQX8 bit_index_reg_0_ ( .D(n68), .CK(clk), .RN(rst_n), .Q(bit_index[0])
         );
  DFFRHQX8 bit_index_reg_2_ ( .D(n63), .CK(clk), .RN(n97), .Q(bit_index[2]) );
  gcd_DW_mult_uns_2 mult_88 ( .a({n193, trial_y[8], n192, n197, n195, n94, 
        trial_y[3:2], n199, trial_y[0]}), .b({n194, trial_y[8:7], n198, n196, 
        n93, trial_y[3:2], n200, trial_y[0]}), .product_19_(trial_square[19]), 
        .product_18_(trial_square[18]), .product_17_(trial_square[17]), 
        .product_16_(trial_square[16]), .product_15_(trial_square[15]), 
        .product_14_(trial_square[14]), .product_13_(trial_square[13]), 
        .product_12_(trial_square[12]), .product_11_(trial_square[11]), 
        .product_10_(trial_square[10]), .product_9_(trial_square[9]), 
        .product_8_(trial_square[8]), .product_7_(trial_square[7]), 
        .product_6_(trial_square[6]), .product_5_(trial_square[5]), 
        .product_4_(trial_square[4]), .product_3_(trial_square[3]), 
        .product_2_(trial_square[2]), .product_0_(trial_square[0]) );
  DFFRQX2 data_reg_reg_9_ ( .D(n51), .CK(clk), .RN(rst_n), .Q(data_reg[9]) );
  DFFRQX2 data_reg_reg_7_ ( .D(n49), .CK(clk), .RN(rst_n), .Q(data_reg[7]) );
  DFFRQX2 data_reg_reg_4_ ( .D(n46), .CK(clk), .RN(rst_n), .Q(data_reg[4]) );
  DFFRQX2 data_reg_reg_6_ ( .D(n48), .CK(clk), .RN(rst_n), .Q(data_reg[6]) );
  DFFRQX2 data_reg_reg_8_ ( .D(n50), .CK(clk), .RN(rst_n), .Q(data_reg[8]) );
  DFFRQX2 data_reg_reg_3_ ( .D(n45), .CK(clk), .RN(rst_n), .Q(data_reg[3]) );
  DFFRQX2 data_reg_reg_5_ ( .D(n47), .CK(clk), .RN(rst_n), .Q(data_reg[5]) );
  DFFRQX2 data_reg_reg_1_ ( .D(n43), .CK(clk), .RN(rst_n), .Q(data_reg[1]) );
  DFFRQX2 data_reg_reg_2_ ( .D(n44), .CK(clk), .RN(rst_n), .Q(data_reg[2]) );
  DFFRQX2 state_reg_0_ ( .D(n65), .CK(clk), .RN(rst_n), .Q(state[0]) );
  DFFRQX2 state_reg_1_ ( .D(n66), .CK(clk), .RN(rst_n), .Q(state[1]) );
  DFFRQX2 data_reg_reg_0_ ( .D(n52), .CK(clk), .RN(rst_n), .Q(data_reg[0]) );
  DFFRX2 y_reg_reg_4_ ( .D(n58), .CK(clk), .RN(n97), .Q(sqr_out[4]), .QN(n72)
         );
  DFFRX2 y_reg_reg_5_ ( .D(n57), .CK(clk), .RN(n97), .Q(sqr_out[5]), .QN(n73)
         );
  DFFRX2 y_reg_reg_7_ ( .D(n55), .CK(clk), .RN(n97), .Q(sqr_out[7]), .QN(n76)
         );
  DFFRX2 y_reg_reg_8_ ( .D(n54), .CK(clk), .RN(n97), .Q(sqr_out[8]), .QN(n69)
         );
  DFFRX2 y_reg_reg_6_ ( .D(n56), .CK(clk), .RN(n97), .Q(sqr_out[6]), .QN(n74)
         );
  DFFRHQX4 bit_index_reg_1_ ( .D(n64), .CK(clk), .RN(n97), .Q(bit_index[1]) );
  DFFRHQX4 bit_index_reg_3_ ( .D(n67), .CK(clk), .RN(n97), .Q(bit_index[3]) );
  DFFRX1 y_reg_reg_2_ ( .D(n60), .CK(clk), .RN(rst_n), .Q(sqr_out[2]), .QN(
        n177) );
  DFFRX2 y_reg_reg_9_ ( .D(n53), .CK(clk), .RN(n97), .Q(sqr_out[9]), .QN(n78)
         );
  DFFRX2 y_reg_reg_3_ ( .D(n59), .CK(clk), .RN(n97), .Q(sqr_out[3]), .QN(n77)
         );
  DFFRX2 y_reg_reg_1_ ( .D(n61), .CK(clk), .RN(n97), .Q(sqr_out[1]), .QN(n75)
         );
  DFFRX2 y_reg_reg_0_ ( .D(n62), .CK(clk), .RN(n97), .Q(sqr_out[0]), .QN(n70)
         );
  NAND2BX4 U81 ( .AN(data_reg[5]), .B(trial_square[14]), .Y(n120) );
  NAND2BX8 U82 ( .AN(trial_square[14]), .B(data_reg[5]), .Y(n139) );
  OAI2BB1X2 U83 ( .A0N(n179), .A1N(n178), .B0(n177), .Y(trial_y[2]) );
  NAND2BX2 U84 ( .AN(n178), .B(n179), .Y(n168) );
  NAND2X4 U85 ( .A(n188), .B(n70), .Y(trial_y[0]) );
  NAND2BX4 U86 ( .AN(trial_square[13]), .B(data_reg[4]), .Y(n140) );
  INVX4 U87 ( .A(bit_index[0]), .Y(n138) );
  INVX4 U88 ( .A(trial_square[17]), .Y(n152) );
  NOR2X4 U89 ( .A(trial_square[9]), .B(n96), .Y(n88) );
  NAND2BX2 U90 ( .AN(trial_square[18]), .B(data_reg[9]), .Y(n135) );
  OAI21X4 U91 ( .A0(n164), .A1(bit_index[2]), .B0(n69), .Y(trial_y[8]) );
  NAND2XL U92 ( .A(trial_square[15]), .B(n118), .Y(n121) );
  INVX3 U93 ( .A(trial_square[15]), .Y(n143) );
  BUFX2 U94 ( .A(n93), .Y(n94) );
  CLKINVX2 U95 ( .A(n174), .Y(n175) );
  CLKINVX2 U96 ( .A(n176), .Y(n179) );
  INVX2 U97 ( .A(bit_index[2]), .Y(n178) );
  BUFX2 U98 ( .A(trial_y[4]), .Y(n93) );
  OAI31X1 U99 ( .A0(n84), .A1(n81), .A2(n178), .B0(n72), .Y(trial_y[4]) );
  INVX2 U100 ( .A(n140), .Y(n141) );
  NAND2X2 U101 ( .A(n139), .B(n140), .Y(n115) );
  NAND3BX2 U102 ( .AN(n138), .B(n84), .C(n137), .Y(n163) );
  OR2X2 U103 ( .A(n71), .B(n86), .Y(n80) );
  NAND2XL U104 ( .A(n151), .B(trial_square[11]), .Y(n82) );
  AND2X4 U105 ( .A(n148), .B(n82), .Y(n157) );
  NAND2BX4 U106 ( .AN(n187), .B(n190), .Y(n173) );
  NAND2BX2 U107 ( .AN(n90), .B(n75), .Y(n200) );
  OR2X2 U108 ( .A(n189), .B(n187), .Y(n71) );
  INVX2 U109 ( .A(trial_square[11]), .Y(n149) );
  INVX2 U110 ( .A(n120), .Y(n118) );
  OR2X4 U111 ( .A(bit_index[2]), .B(n172), .Y(n188) );
  OAI21X1 U112 ( .A0(n132), .A1(trial_square[17]), .B0(n153), .Y(n129) );
  NAND2BX8 U113 ( .AN(bit_index[1]), .B(n138), .Y(n81) );
  NAND2X2 U114 ( .A(n165), .B(bit_index[2]), .Y(n171) );
  CLKINVX4 U115 ( .A(n165), .Y(n189) );
  OR3X4 U116 ( .A(trial_square[5]), .B(trial_square[6]), .C(trial_square[4]), 
        .Y(n79) );
  OR2X4 U117 ( .A(n79), .B(trial_square[7]), .Y(n144) );
  CLKINVX4 U118 ( .A(n136), .Y(n190) );
  OAI2BB1X2 U119 ( .A0N(sqr_out[0]), .A1N(n191), .B0(n80), .Y(n62) );
  AOI21X2 U120 ( .A0(trial_square[17]), .A1(n132), .B0(n131), .Y(n89) );
  INVX2 U121 ( .A(n139), .Y(n142) );
  INVX4 U122 ( .A(n168), .Y(n185) );
  OAI32X1 U123 ( .A0(n182), .A1(n181), .A2(n176), .B0(n180), .B1(n177), .Y(n60) );
  AOI211X2 U124 ( .A0(trial_square[18]), .A1(n160), .B0(trial_square[19]), 
        .C0(n133), .Y(n134) );
  OAI2B1X4 U125 ( .A1N(n135), .A0(n89), .B0(n134), .Y(n136) );
  AOI21X2 U126 ( .A0(n117), .A1(n116), .B0(n115), .Y(n126) );
  NAND2BX8 U127 ( .AN(n185), .B(n74), .Y(n198) );
  NAND2BX4 U128 ( .AN(n81), .B(n84), .Y(n164) );
  INVX2 U129 ( .A(n85), .Y(n86) );
  OAI32XL U130 ( .A0(n182), .A1(n183), .A2(n181), .B0(n180), .B1(n75), .Y(n61)
         );
  OR4X4 U131 ( .A(n144), .B(trial_square[3]), .C(trial_square[0]), .D(
        trial_square[2]), .Y(n146) );
  INVXL U132 ( .A(bit_index[3]), .Y(n167) );
  CLKINVX4 U133 ( .A(n166), .Y(n184) );
  NAND2BX4 U134 ( .AN(n178), .B(n175), .Y(n166) );
  CLKINVX4 U135 ( .A(n170), .Y(n186) );
  NAND2BX8 U136 ( .AN(n183), .B(bit_index[2]), .Y(n170) );
  OR2X4 U137 ( .A(n84), .B(n81), .Y(n172) );
  CLKINVX4 U138 ( .A(n83), .Y(n84) );
  INVXL U139 ( .A(bit_index[1]), .Y(n137) );
  NAND2BX8 U140 ( .AN(n184), .B(n76), .Y(trial_y[7]) );
  NAND2XL U141 ( .A(trial_square[15]), .B(n119), .Y(n122) );
  AOI21X4 U142 ( .A0(n126), .A1(n125), .B0(n124), .Y(n128) );
  OA21X4 U143 ( .A0(trial_square[18]), .A1(n160), .B0(n159), .Y(n87) );
  AOI211X4 U144 ( .A0(data_reg[6]), .A1(n143), .B0(n142), .C0(n141), .Y(n159)
         );
  NOR3X4 U145 ( .A(n128), .B(n129), .C(n127), .Y(n187) );
  NAND2BX8 U146 ( .AN(n186), .B(n73), .Y(n196) );
  OAI2B11X4 U147 ( .A1N(n149), .A0(n151), .B0(trial_square[10]), .C0(n150), 
        .Y(n156) );
  OAI221X4 U148 ( .A0(trial_square[10]), .A1(n150), .B0(trial_square[11]), 
        .B1(n151), .C0(n147), .Y(n148) );
  NOR2X1 U149 ( .A(bit_index[2]), .B(n183), .Y(n90) );
  OR2X4 U150 ( .A(n169), .B(bit_index[1]), .Y(n183) );
  NAND2X4 U151 ( .A(n87), .B(n158), .Y(n165) );
  NAND2BX4 U152 ( .AN(n187), .B(n190), .Y(n182) );
  NOR2X1 U153 ( .A(bit_index[2]), .B(n163), .Y(n91) );
  NAND2BX8 U154 ( .AN(bit_index[3]), .B(bit_index[0]), .Y(n169) );
  NAND3BX4 U155 ( .AN(bit_index[0]), .B(bit_index[1]), .C(n167), .Y(n176) );
  INVXL U156 ( .A(bit_index[3]), .Y(n83) );
  NOR2XL U157 ( .A(n188), .B(n136), .Y(n85) );
  NAND2BX2 U158 ( .AN(n169), .B(bit_index[1]), .Y(n174) );
  INVX2 U159 ( .A(n153), .Y(n154) );
  NAND2XL U160 ( .A(n114), .B(trial_square[13]), .Y(n116) );
  NAND2BX1 U161 ( .AN(n90), .B(n75), .Y(n199) );
  NAND2X2 U162 ( .A(data_reg[6]), .B(n143), .Y(n125) );
  MX2XL U163 ( .A(n105), .B(n106), .S0(bit_index[2]), .Y(n63) );
  OR2XL U164 ( .A(bit_index[2]), .B(n106), .Y(n108) );
  INVX2 U165 ( .A(n191), .Y(n180) );
  INVX2 U166 ( .A(n99), .Y(n101) );
  NAND2BX2 U167 ( .AN(n100), .B(n162), .Y(n99) );
  INVX2 U168 ( .A(n100), .Y(n104) );
  INVX2 U169 ( .A(n110), .Y(n66) );
  NAND2BX2 U170 ( .AN(n162), .B(n161), .Y(n191) );
  AO2B2X4 U171 ( .B0(n96), .B1(trial_square[9]), .A0(trial_square[8]), .A1N(
        n88), .Y(n145) );
  OAI32XL U172 ( .A0(n173), .A1(n183), .A2(n171), .B0(n180), .B1(n73), .Y(n57)
         );
  OAI32XL U173 ( .A0(n173), .A1(n176), .A2(n171), .B0(n180), .B1(n74), .Y(n56)
         );
  OAI32XL U174 ( .A0(n173), .A1(n172), .A2(n171), .B0(n180), .B1(n72), .Y(n58)
         );
  OAI32XL U175 ( .A0(n173), .A1(n174), .A2(n171), .B0(n180), .B1(n76), .Y(n55)
         );
  NAND2BX1 U176 ( .AN(n185), .B(n74), .Y(n197) );
  NOR2X1 U177 ( .A(trial_square[18]), .B(n160), .Y(n127) );
  NAND3X2 U178 ( .A(n123), .B(n122), .C(n121), .Y(n124) );
  NAND2X2 U179 ( .A(n118), .B(n119), .Y(n123) );
  NAND2X2 U180 ( .A(n113), .B(trial_square[12]), .Y(n117) );
  NAND2BX2 U181 ( .AN(n91), .B(n78), .Y(n194) );
  NAND2BX2 U182 ( .AN(n91), .B(n78), .Y(n193) );
  OAI2BB1X1 U183 ( .A0N(n109), .A1N(n133), .B0(n110), .Y(n100) );
  INVX2 U184 ( .A(n133), .Y(n162) );
  INVX2 U185 ( .A(n111), .Y(n112) );
  INVX2 U186 ( .A(n109), .Y(n161) );
  INVX2 U187 ( .A(n98), .Y(n97) );
  NAND2BX2 U188 ( .AN(trial_square[16]), .B(data_reg[7]), .Y(n153) );
  INVX2 U189 ( .A(data_reg[0]), .Y(n96) );
  INVX2 U190 ( .A(n103), .Y(n105) );
  NAND2X2 U191 ( .A(n92), .B(n107), .Y(n68) );
  MXI2XL U192 ( .A(n101), .B(n100), .S0(bit_index[0]), .Y(n92) );
  NAND2BX2 U193 ( .AN(state[1]), .B(state[0]), .Y(n133) );
  NAND2BX2 U194 ( .AN(state[0]), .B(n104), .Y(n107) );
  INVX2 U195 ( .A(data_reg[2]), .Y(n151) );
  INVX2 U196 ( .A(data_reg[1]), .Y(n150) );
  NAND2BX2 U197 ( .AN(state[1]), .B(in_valid), .Y(n109) );
  INVX2 U198 ( .A(data_reg[6]), .Y(n119) );
  INVX2 U199 ( .A(data_reg[4]), .Y(n114) );
  INVX2 U200 ( .A(data_reg[3]), .Y(n113) );
  INVX2 U201 ( .A(data_reg[8]), .Y(n132) );
  INVX2 U202 ( .A(data_reg[9]), .Y(n160) );
  NAND2BX2 U203 ( .AN(state[0]), .B(n161), .Y(n111) );
  MX2X1 U204 ( .A(data_reg[0]), .B(data_in[0]), .S0(n112), .Y(n52) );
  MX2X1 U205 ( .A(data_reg[1]), .B(data_in[1]), .S0(n112), .Y(n43) );
  MX2X1 U206 ( .A(data_reg[2]), .B(data_in[2]), .S0(n112), .Y(n44) );
  MX2X1 U207 ( .A(data_reg[3]), .B(data_in[3]), .S0(n112), .Y(n45) );
  MX2X1 U208 ( .A(data_reg[4]), .B(data_in[4]), .S0(n112), .Y(n46) );
  MX2X1 U209 ( .A(data_reg[5]), .B(data_in[5]), .S0(n112), .Y(n47) );
  MX2X1 U210 ( .A(data_reg[6]), .B(data_in[6]), .S0(n112), .Y(n48) );
  MX2X1 U211 ( .A(data_reg[7]), .B(data_in[7]), .S0(n112), .Y(n49) );
  MX2X1 U212 ( .A(data_reg[8]), .B(data_in[8]), .S0(n112), .Y(n50) );
  MX2X1 U213 ( .A(data_reg[9]), .B(data_in[9]), .S0(n112), .Y(n51) );
  NOR2BX1 U214 ( .AN(state[1]), .B(state[0]), .Y(out_valid) );
  INVX2 U215 ( .A(rst_n), .Y(n98) );
  NAND2BX2 U216 ( .AN(n186), .B(n73), .Y(n195) );
  NAND2BX1 U217 ( .AN(n184), .B(n76), .Y(n192) );
  OAI2BB1XL U218 ( .A0N(n162), .A1N(n81), .B0(n104), .Y(n106) );
  NAND2BX1 U219 ( .AN(n81), .B(n101), .Y(n103) );
  INVX2 U220 ( .A(trial_square[16]), .Y(n130) );
  OR2XL U221 ( .A(trial_square[9]), .B(n96), .Y(n95) );
  AOI211X1 U222 ( .A0(data_reg[8]), .A1(n152), .B0(data_reg[7]), .C0(n130), 
        .Y(n131) );
  NAND2BX2 U223 ( .AN(bit_index[2]), .B(n165), .Y(n181) );
  OAI2BB2X2 U224 ( .B0(n113), .B1(trial_square[12]), .A0N(data_reg[8]), .A1N(
        n152), .Y(n155) );
  OAI2BB1XL U225 ( .A0N(bit_index[0]), .A1N(n162), .B0(n104), .Y(n102) );
  OAI32XL U226 ( .A0(n182), .A1(n164), .A2(n181), .B0(n180), .B1(n69), .Y(n54)
         );
  OAI32XL U227 ( .A0(n182), .A1(n163), .A2(n181), .B0(n180), .B1(n78), .Y(n53)
         );
  OAI2BB1XL U228 ( .A0N(n84), .A1N(n108), .B0(n107), .Y(n67) );
  OAI2BB1XL U229 ( .A0N(n162), .A1N(n188), .B0(n111), .Y(n65) );
  NAND2BX1 U230 ( .AN(n188), .B(n162), .Y(n110) );
  OAI2BB1XL U231 ( .A0N(bit_index[1]), .A1N(n102), .B0(n103), .Y(n64) );
  OAI32XL U232 ( .A0(n182), .A1(n174), .A2(n181), .B0(n180), .B1(n77), .Y(n59)
         );
  AO21X4 U233 ( .A0(n146), .A1(n95), .B0(n145), .Y(n147) );
  AOI211X4 U234 ( .A0(n157), .A1(n156), .B0(n155), .C0(n154), .Y(n158) );
  OAI2BB1X4 U235 ( .A0N(n178), .A1N(n175), .B0(n77), .Y(trial_y[3]) );
endmodule

