/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : X-2025.06
// Date      : Wed Sep 23 12:41:21 2026
/////////////////////////////////////////////////////////////


module gcd ( sqr_out, out_valid, clk, rst_n, data_in, in_valid );
  output [9:0] sqr_out;
  input [9:0] data_in;
  input clk, rst_n, in_valid;
  output out_valid;
  wire   N18, n24, n25, n26, n27, n29, n32, n33, n35, n37, n38, n40, n42, n43,
         n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57,
         n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71,
         n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85,
         n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99,
         n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n129, n130, n131, n132,
         n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, n143,
         n144, n145, SYNOPSYS_UNCONNECTED_1;
  wire   [9:0] data_reg;
  wire   [1:0] state;
  wire   [3:0] bit_index;
  wire   [19:0] trial_square;
  wire   [9:0] trial_y;

  gcd_DW_mult_uns_0 mult_85 ( .a(trial_y), .b(trial_y), .product({
        trial_square[19:2], SYNOPSYS_UNCONNECTED_1, trial_square[0]}) );
  DFFRQX2 data_reg_reg_1_ ( .D(n43), .CK(clk), .RN(n80), .Q(data_reg[1]) );
  DFFRQX2 data_reg_reg_2_ ( .D(n44), .CK(clk), .RN(n80), .Q(data_reg[2]) );
  DFFRQX2 data_reg_reg_7_ ( .D(n49), .CK(clk), .RN(n80), .Q(data_reg[7]) );
  DFFRQX2 data_reg_reg_9_ ( .D(n51), .CK(clk), .RN(n80), .Q(data_reg[9]) );
  DFFRQX2 data_reg_reg_0_ ( .D(n52), .CK(clk), .RN(n80), .Q(data_reg[0]) );
  DFFRQX2 data_reg_reg_3_ ( .D(n45), .CK(clk), .RN(n80), .Q(data_reg[3]) );
  DFFRQX2 data_reg_reg_4_ ( .D(n46), .CK(clk), .RN(n80), .Q(data_reg[4]) );
  DFFRQX2 data_reg_reg_8_ ( .D(n50), .CK(clk), .RN(n80), .Q(data_reg[8]) );
  DFFRQX2 data_reg_reg_5_ ( .D(n47), .CK(clk), .RN(n80), .Q(data_reg[5]) );
  DFFRQX2 data_reg_reg_6_ ( .D(n48), .CK(clk), .RN(n80), .Q(data_reg[6]) );
  DFFRQX2 state_reg_0_ ( .D(n65), .CK(clk), .RN(n80), .Q(state[0]) );
  DFFRQX2 state_reg_1_ ( .D(n66), .CK(clk), .RN(n80), .Q(state[1]) );
  DFFRX1 y_reg_reg_9_ ( .D(n53), .CK(clk), .RN(n79), .Q(sqr_out[9]), .QN(n138)
         );
  DFFRX1 y_reg_reg_8_ ( .D(n54), .CK(clk), .RN(n79), .Q(sqr_out[8]), .QN(n137)
         );
  DFFRX1 y_reg_reg_7_ ( .D(n55), .CK(clk), .RN(n79), .Q(sqr_out[7]), .QN(n136)
         );
  DFFRX1 y_reg_reg_6_ ( .D(n56), .CK(clk), .RN(n79), .Q(sqr_out[6]), .QN(n135)
         );
  DFFRX1 y_reg_reg_5_ ( .D(n57), .CK(clk), .RN(n79), .Q(sqr_out[5]), .QN(n134)
         );
  DFFRX1 y_reg_reg_4_ ( .D(n58), .CK(clk), .RN(n79), .Q(sqr_out[4]), .QN(n133)
         );
  DFFRX1 y_reg_reg_3_ ( .D(n59), .CK(clk), .RN(n79), .Q(sqr_out[3]), .QN(n132)
         );
  DFFRX1 y_reg_reg_2_ ( .D(n60), .CK(clk), .RN(n79), .Q(sqr_out[2]), .QN(n131)
         );
  DFFRX1 y_reg_reg_0_ ( .D(n62), .CK(clk), .RN(n79), .Q(sqr_out[0]), .QN(n129)
         );
  DFFRX1 y_reg_reg_1_ ( .D(n61), .CK(clk), .RN(n79), .Q(sqr_out[1]), .QN(n130)
         );
  DFFRQX2 bit_index_reg_0_ ( .D(n68), .CK(clk), .RN(n80), .Q(bit_index[0]) );
  DFFRQX2 bit_index_reg_3_ ( .D(n67), .CK(clk), .RN(n79), .Q(bit_index[3]) );
  DFFRQX2 bit_index_reg_1_ ( .D(n64), .CK(clk), .RN(n79), .Q(bit_index[1]) );
  DFFRQX2 bit_index_reg_2_ ( .D(n63), .CK(clk), .RN(n79), .Q(bit_index[2]) );
  INVX2 U81 ( .A(trial_square[17]), .Y(n116) );
  INVX2 U82 ( .A(trial_square[15]), .Y(n113) );
  INVX2 U83 ( .A(trial_square[14]), .Y(n112) );
  INVX2 U84 ( .A(trial_square[18]), .Y(n118) );
  OR2X2 U85 ( .A(n143), .B(n139), .Y(n69) );
  NAND2X2 U86 ( .A(N18), .B(n27), .Y(n26) );
  OAI22X1 U87 ( .A0(n25), .A1(n138), .B0(n26), .B1(n78), .Y(n53) );
  OAI22X1 U88 ( .A0(n25), .A1(n137), .B0(n26), .B1(n77), .Y(n54) );
  OAI22X1 U89 ( .A0(n25), .A1(n136), .B0(n26), .B1(n76), .Y(n55) );
  OAI22X1 U90 ( .A0(n25), .A1(n135), .B0(n26), .B1(n75), .Y(n56) );
  OAI22X1 U91 ( .A0(n25), .A1(n134), .B0(n26), .B1(n74), .Y(n57) );
  OAI22X1 U92 ( .A0(n25), .A1(n133), .B0(n26), .B1(n73), .Y(n58) );
  OAI22X1 U93 ( .A0(n25), .A1(n132), .B0(n26), .B1(n72), .Y(n59) );
  OAI22X1 U94 ( .A0(n25), .A1(n131), .B0(n26), .B1(n71), .Y(n60) );
  OAI22X1 U95 ( .A0(n25), .A1(n130), .B0(n26), .B1(n70), .Y(n61) );
  OAI22X1 U96 ( .A0(n25), .A1(n129), .B0(n26), .B1(n69), .Y(n62) );
  NAND2X2 U97 ( .A(n127), .B(n128), .Y(n139) );
  NAND2X2 U98 ( .A(n130), .B(n70), .Y(trial_y[1]) );
  OR2X2 U99 ( .A(n144), .B(n139), .Y(n70) );
  NAND2X2 U100 ( .A(n131), .B(n71), .Y(trial_y[2]) );
  OR2X2 U101 ( .A(n140), .B(n139), .Y(n71) );
  NAND2X2 U102 ( .A(n123), .B(n126), .Y(n143) );
  NAND2X2 U103 ( .A(n129), .B(n69), .Y(trial_y[0]) );
  INVX2 U104 ( .A(n99), .Y(n114) );
  INVX2 U105 ( .A(n105), .Y(n119) );
  NAND2X2 U106 ( .A(n132), .B(n72), .Y(trial_y[3]) );
  OR2X2 U107 ( .A(n141), .B(n139), .Y(n72) );
  OR2X2 U108 ( .A(n143), .B(n142), .Y(n73) );
  NAND2X2 U109 ( .A(n133), .B(n73), .Y(trial_y[4]) );
  OR2X2 U110 ( .A(n144), .B(n142), .Y(n74) );
  NAND2X2 U111 ( .A(n134), .B(n74), .Y(trial_y[5]) );
  NAND2X2 U112 ( .A(n135), .B(n75), .Y(trial_y[6]) );
  OR2X2 U113 ( .A(n142), .B(n140), .Y(n75) );
  NAND2X2 U114 ( .A(n136), .B(n76), .Y(trial_y[7]) );
  OR2X2 U115 ( .A(n142), .B(n141), .Y(n76) );
  NAND2X2 U116 ( .A(n137), .B(n77), .Y(trial_y[8]) );
  OR2X2 U117 ( .A(n145), .B(n143), .Y(n77) );
  NAND2X2 U118 ( .A(n138), .B(n78), .Y(trial_y[9]) );
  OR2X2 U119 ( .A(n145), .B(n144), .Y(n78) );
  OAI21X1 U120 ( .A0(n124), .A1(n126), .B0(n33), .Y(n32) );
  OA21X1 U121 ( .A0(n124), .A1(n123), .B0(n40), .Y(n33) );
  NAND3XL U122 ( .A(n27), .B(n123), .C(n40), .Y(n29) );
  INVX2 U123 ( .A(n24), .Y(n120) );
  OAI211XL U124 ( .A0(n40), .A1(n123), .B0(n29), .C0(n37), .Y(n68) );
  NAND2X2 U125 ( .A(n40), .B(n125), .Y(n37) );
  OAI21X1 U126 ( .A0(n35), .A1(n124), .B0(n120), .Y(n65) );
  INVX2 U127 ( .A(n94), .Y(n111) );
  INVX2 U128 ( .A(n27), .Y(n124) );
  AND2X2 U129 ( .A(n35), .B(n27), .Y(n66) );
  INVX2 U130 ( .A(n81), .Y(n79) );
  INVX2 U131 ( .A(n81), .Y(n80) );
  INVX2 U132 ( .A(bit_index[2]), .Y(n127) );
  NAND2X2 U133 ( .A(bit_index[0]), .B(n126), .Y(n144) );
  INVX2 U134 ( .A(bit_index[1]), .Y(n126) );
  INVX2 U135 ( .A(bit_index[3]), .Y(n128) );
  INVX2 U136 ( .A(trial_square[16]), .Y(n115) );
  INVX2 U137 ( .A(n85), .Y(n117) );
  INVX2 U138 ( .A(bit_index[0]), .Y(n123) );
  NAND2X2 U139 ( .A(bit_index[1]), .B(n123), .Y(n140) );
  NAND2X2 U140 ( .A(bit_index[1]), .B(bit_index[0]), .Y(n141) );
  NAND2X2 U141 ( .A(bit_index[2]), .B(n128), .Y(n142) );
  NAND2X2 U142 ( .A(bit_index[3]), .B(n127), .Y(n145) );
  NOR2BX1 U143 ( .AN(n42), .B(n66), .Y(n40) );
  OAI21X1 U144 ( .A0(state[1]), .A1(n122), .B0(n124), .Y(n42) );
  INVX2 U145 ( .A(in_valid), .Y(n122) );
  NAND2X2 U146 ( .A(n37), .B(n38), .Y(n67) );
  OAI21X1 U147 ( .A0(bit_index[2]), .A1(n32), .B0(bit_index[3]), .Y(n38) );
  INVX2 U148 ( .A(data_reg[2]), .Y(n107) );
  OAI32XL U149 ( .A0(n29), .A1(bit_index[2]), .A2(bit_index[1]), .B0(n121), 
        .B1(n127), .Y(n63) );
  INVX2 U150 ( .A(n32), .Y(n121) );
  OAI22X1 U151 ( .A0(n33), .A1(n126), .B0(bit_index[1]), .B1(n29), .Y(n64) );
  NOR3X1 U152 ( .A(state[0]), .B(state[1]), .C(n122), .Y(n24) );
  AO22X2 U153 ( .A0(data_reg[1]), .A1(n120), .B0(data_in[1]), .B1(n24), .Y(n43) );
  AO22X2 U154 ( .A0(data_reg[2]), .A1(n120), .B0(data_in[2]), .B1(n24), .Y(n44) );
  AO22X2 U155 ( .A0(data_reg[3]), .A1(n120), .B0(data_in[3]), .B1(n24), .Y(n45) );
  AO22X2 U156 ( .A0(data_reg[4]), .A1(n120), .B0(data_in[4]), .B1(n24), .Y(n46) );
  AO22X2 U157 ( .A0(data_reg[5]), .A1(n120), .B0(data_in[5]), .B1(n24), .Y(n47) );
  AO22X2 U158 ( .A0(data_reg[6]), .A1(n120), .B0(data_in[6]), .B1(n24), .Y(n48) );
  AO22X2 U159 ( .A0(data_reg[7]), .A1(n120), .B0(data_in[7]), .B1(n24), .Y(n49) );
  AO22X2 U160 ( .A0(data_reg[8]), .A1(n120), .B0(data_in[8]), .B1(n24), .Y(n50) );
  AO22X2 U161 ( .A0(data_reg[9]), .A1(n120), .B0(data_in[9]), .B1(n24), .Y(n51) );
  AO22X2 U162 ( .A0(data_reg[0]), .A1(n120), .B0(data_in[0]), .B1(n24), .Y(n52) );
  NOR3X1 U163 ( .A(n27), .B(state[1]), .C(n122), .Y(n25) );
  NOR2BX1 U164 ( .AN(state[1]), .B(state[0]), .Y(out_valid) );
  INVX2 U165 ( .A(data_reg[3]), .Y(n108) );
  INVX2 U166 ( .A(data_reg[4]), .Y(n109) );
  INVX2 U167 ( .A(data_reg[0]), .Y(n110) );
  INVX2 U168 ( .A(data_reg[1]), .Y(n106) );
  NOR2X2 U169 ( .A(n125), .B(state[1]), .Y(n27) );
  INVX2 U170 ( .A(state[0]), .Y(n125) );
  NOR4X2 U171 ( .A(bit_index[0]), .B(bit_index[1]), .C(bit_index[2]), .D(
        bit_index[3]), .Y(n35) );
  INVX2 U172 ( .A(rst_n), .Y(n81) );
  CLKNAND2X2 U173 ( .A(data_reg[8]), .B(n116), .Y(n85) );
  CLKNAND2X2 U174 ( .A(data_reg[9]), .B(n118), .Y(n86) );
  OAI2B11X1 U175 ( .A1N(data_reg[7]), .A0(trial_square[16]), .B0(n85), .C0(n86), .Y(n100) );
  NAND2BX1 U176 ( .AN(trial_square[13]), .B(data_reg[4]), .Y(n98) );
  AOI32XL U177 ( .A0(trial_square[12]), .A1(n108), .A2(n98), .B0(n109), .B1(
        trial_square[13]), .Y(n84) );
  AND2X1 U178 ( .A(data_reg[6]), .B(n113), .Y(n82) );
  OAI32XL U179 ( .A0(n112), .A1(data_reg[5]), .A2(n82), .B0(data_reg[6]), .B1(
        n113), .Y(n83) );
  AOI21X1 U180 ( .A0(n112), .A1(data_reg[5]), .B0(n82), .Y(n99) );
  OAI2B2X1 U181 ( .A1N(n84), .A0(n83), .B0(n99), .B1(n83), .Y(n90) );
  OAI21BX1 U182 ( .A0(data_reg[9]), .A1(n118), .B0N(trial_square[19]), .Y(n88)
         );
  OAI32XL U183 ( .A0(n115), .A1(data_reg[7]), .A2(n117), .B0(data_reg[8]), 
        .B1(n116), .Y(n87) );
  OAI22X1 U184 ( .A0(n88), .A1(n87), .B0(n88), .B1(n86), .Y(n89) );
  OAI21X1 U185 ( .A0(n100), .A1(n90), .B0(n89), .Y(n105) );
  NOR2X1 U186 ( .A(n110), .B(trial_square[9]), .Y(n94) );
  AOI22XL U187 ( .A0(trial_square[9]), .A1(n110), .B0(trial_square[8]), .B1(
        n111), .Y(n93) );
  NAND2BX1 U188 ( .AN(trial_square[11]), .B(data_reg[2]), .Y(n91) );
  AOI32XL U189 ( .A0(trial_square[10]), .A1(n106), .A2(n91), .B0(n107), .B1(
        trial_square[11]), .Y(n92) );
  OAI21X1 U190 ( .A0(trial_square[10]), .A1(n106), .B0(n91), .Y(n95) );
  AOI22XL U191 ( .A0(n93), .A1(n92), .B0(n92), .B1(n95), .Y(n104) );
  NOR4X1 U192 ( .A(trial_square[7]), .B(trial_square[6]), .C(trial_square[5]), 
        .D(trial_square[4]), .Y(n96) );
  AOI211X1 U193 ( .A0(n97), .A1(n96), .B0(n95), .C0(n94), .Y(n103) );
  OAI21X1 U194 ( .A0(trial_square[12]), .A1(n108), .B0(n98), .Y(n101) );
  OAI31X1 U195 ( .A0(n101), .A1(n100), .A2(n114), .B0(n119), .Y(n102) );
  OAI31X1 U196 ( .A0(n105), .A1(n104), .A2(n103), .B0(n102), .Y(N18) );
  NOR3X1 U197 ( .A(trial_square[0]), .B(trial_square[3]), .C(trial_square[2]), 
        .Y(n97) );
endmodule


module gcd_DW_mult_uns_0 ( a, b, product );
  input [9:0] a;
  input [9:0] b;
  output [19:0] product;
  wire   n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72,
         n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86,
         n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n164, n165, n166, n167, n168, n169, n170, n171, n172, n173;

  ADDFX1 U2 ( .A(n67), .B(a[9]), .CI(n2), .CO(product[19]), .S(product[18]) );
  ADDFX1 U3 ( .A(n18), .B(n68), .CI(n3), .CO(n2), .S(product[17]) );
  ADDFX1 U4 ( .A(n20), .B(n19), .CI(n4), .CO(n3), .S(product[16]) );
  ADDFX1 U5 ( .A(n23), .B(n21), .CI(n5), .CO(n4), .S(product[15]) );
  ADDFX1 U6 ( .A(n26), .B(n24), .CI(n6), .CO(n5), .S(product[14]) );
  ADDFX1 U7 ( .A(n29), .B(n27), .CI(n7), .CO(n6), .S(product[13]) );
  ADDFX1 U8 ( .A(n30), .B(n34), .CI(n8), .CO(n7), .S(product[12]) );
  ADDFX1 U9 ( .A(n35), .B(n39), .CI(n9), .CO(n8), .S(product[11]) );
  ADDFX1 U10 ( .A(n40), .B(n46), .CI(n10), .CO(n9), .S(product[10]) );
  ADDFX1 U11 ( .A(n47), .B(n51), .CI(n11), .CO(n10), .S(product[9]) );
  ADDFX1 U12 ( .A(n52), .B(n55), .CI(n12), .CO(n11), .S(product[8]) );
  ADDFX1 U13 ( .A(n56), .B(n59), .CI(n13), .CO(n12), .S(product[7]) );
  ADDFX1 U14 ( .A(n60), .B(n62), .CI(n14), .CO(n13), .S(product[6]) );
  ADDFX1 U15 ( .A(n64), .B(n65), .CI(n15), .CO(n14), .S(product[5]) );
  ADDFX1 U16 ( .A(n66), .B(n108), .CI(n16), .CO(n15), .S(product[4]) );
  ADDHX1 U17 ( .A(n110), .B(n17), .CO(n16), .S(product[3]) );
  ADDHX1 U18 ( .A(a[1]), .B(n111), .CO(n17), .S(product[2]) );
  ADDFX1 U19 ( .A(n69), .B(a[8]), .CI(n76), .CO(n18), .S(n19) );
  ADDFX1 U20 ( .A(n70), .B(n77), .CI(n22), .CO(n20), .S(n21) );
  CMPR42X1 U21 ( .A(a[7]), .B(n71), .C(n78), .D(n84), .ICI(n25), .S(n24), 
        .ICO(n22), .CO(n23) );
  CMPR42X1 U22 ( .A(n85), .B(n72), .C(n79), .D(n31), .ICI(n28), .S(n27), .ICO(
        n25), .CO(n26) );
  CMPR42X1 U23 ( .A(n91), .B(n86), .C(n32), .D(n36), .ICI(n33), .S(n30), .ICO(
        n28), .CO(n29) );
  ADDFX1 U24 ( .A(n73), .B(a[6]), .CI(n80), .CO(n31), .S(n32) );
  CMPR42X1 U25 ( .A(n87), .B(n81), .C(n38), .D(n37), .ICI(n41), .S(n35), .ICO(
        n33), .CO(n34) );
  ADDFX1 U26 ( .A(n74), .B(n92), .CI(n43), .CO(n36), .S(n37) );
  CMPR42X1 U27 ( .A(n88), .B(n93), .C(n44), .D(n45), .ICI(n42), .S(n40), .ICO(
        n38), .CO(n39) );
  ADDFX1 U28 ( .A(n82), .B(n97), .CI(n48), .CO(n41), .S(n42) );
  ADDHX1 U29 ( .A(a[5]), .B(n75), .CO(n43), .S(n44) );
  CMPR42X1 U30 ( .A(n98), .B(n94), .C(n53), .D(n49), .ICI(n50), .S(n47), .ICO(
        n45), .CO(n46) );
  ADDHX1 U31 ( .A(n89), .B(n83), .CO(n48), .S(n49) );
  CMPR42X1 U32 ( .A(n102), .B(n95), .C(n99), .D(n57), .ICI(n54), .S(n52), 
        .ICO(n50), .CO(n51) );
  ADDHX1 U33 ( .A(a[4]), .B(n90), .CO(n53), .S(n54) );
  ADDFX1 U34 ( .A(n61), .B(n100), .CI(n58), .CO(n55), .S(n56) );
  ADDHX1 U35 ( .A(n103), .B(n96), .CO(n57), .S(n58) );
  ADDFX1 U36 ( .A(n104), .B(n106), .CI(n63), .CO(n59), .S(n60) );
  ADDHX1 U37 ( .A(a[3]), .B(n101), .CO(n61), .S(n62) );
  ADDHX1 U38 ( .A(n107), .B(n105), .CO(n63), .S(n64) );
  ADDHX1 U39 ( .A(a[2]), .B(n109), .CO(n65), .S(n66) );
  INVX2 U106 ( .A(b[1]), .Y(n169) );
  INVX2 U107 ( .A(b[2]), .Y(n167) );
  INVX2 U108 ( .A(b[0]), .Y(n164) );
  INVX2 U109 ( .A(b[3]), .Y(n172) );
  INVX2 U110 ( .A(b[4]), .Y(n165) );
  INVX2 U111 ( .A(b[5]), .Y(n170) );
  INVX2 U112 ( .A(b[6]), .Y(n168) );
  INVX2 U113 ( .A(b[7]), .Y(n173) );
  INVX2 U114 ( .A(b[8]), .Y(n166) );
  INVX2 U115 ( .A(b[9]), .Y(n171) );
  BUFX2 U116 ( .A(b[0]), .Y(product[0]) );
  NOR2X1 U117 ( .A(n167), .B(n170), .Y(n99) );
  NOR2X1 U118 ( .A(n170), .B(n172), .Y(n98) );
  NOR2X1 U119 ( .A(n170), .B(n165), .Y(n97) );
  NOR2X1 U120 ( .A(n164), .B(n168), .Y(n96) );
  NOR2X1 U121 ( .A(n168), .B(n169), .Y(n95) );
  NOR2X1 U122 ( .A(n167), .B(n168), .Y(n94) );
  NOR2X1 U123 ( .A(n172), .B(n168), .Y(n93) );
  NOR2X1 U124 ( .A(n165), .B(n168), .Y(n92) );
  NOR2X1 U125 ( .A(n170), .B(n168), .Y(n91) );
  NOR2X1 U126 ( .A(n164), .B(n173), .Y(n90) );
  NOR2X1 U127 ( .A(n169), .B(n173), .Y(n89) );
  NOR2X1 U128 ( .A(n167), .B(n173), .Y(n88) );
  NOR2X1 U129 ( .A(n172), .B(n173), .Y(n87) );
  NOR2X1 U130 ( .A(n165), .B(n173), .Y(n86) );
  NOR2X1 U131 ( .A(n170), .B(n173), .Y(n85) );
  NOR2X1 U132 ( .A(n168), .B(n173), .Y(n84) );
  NOR2X1 U133 ( .A(n164), .B(n166), .Y(n83) );
  NOR2X1 U134 ( .A(n169), .B(n166), .Y(n82) );
  NOR2X1 U135 ( .A(n167), .B(n166), .Y(n81) );
  NOR2X1 U136 ( .A(n172), .B(n166), .Y(n80) );
  NOR2X1 U137 ( .A(n165), .B(n166), .Y(n79) );
  NOR2X1 U138 ( .A(n170), .B(n166), .Y(n78) );
  NOR2X1 U139 ( .A(n168), .B(n166), .Y(n77) );
  NOR2X1 U140 ( .A(n173), .B(n166), .Y(n76) );
  NOR2X1 U141 ( .A(n164), .B(n171), .Y(n75) );
  NOR2X1 U142 ( .A(n169), .B(n171), .Y(n74) );
  NOR2X1 U143 ( .A(n167), .B(n171), .Y(n73) );
  NOR2X1 U144 ( .A(n172), .B(n171), .Y(n72) );
  NOR2X1 U145 ( .A(n165), .B(n171), .Y(n71) );
  NOR2X1 U146 ( .A(n170), .B(n171), .Y(n70) );
  NOR2X1 U147 ( .A(n168), .B(n171), .Y(n69) );
  NOR2X1 U148 ( .A(n173), .B(n171), .Y(n68) );
  NOR2X1 U149 ( .A(n166), .B(n171), .Y(n67) );
  NOR2X1 U150 ( .A(n164), .B(n169), .Y(n111) );
  NOR2X1 U151 ( .A(n167), .B(n164), .Y(n110) );
  NOR2X1 U152 ( .A(n167), .B(n169), .Y(n109) );
  NOR2X1 U153 ( .A(n172), .B(n164), .Y(n108) );
  NOR2X1 U154 ( .A(n172), .B(n169), .Y(n107) );
  NOR2X1 U155 ( .A(n167), .B(n172), .Y(n106) );
  NOR2X1 U156 ( .A(n165), .B(n164), .Y(n105) );
  NOR2X1 U157 ( .A(n165), .B(n169), .Y(n104) );
  NOR2X1 U158 ( .A(n167), .B(n165), .Y(n103) );
  NOR2X1 U159 ( .A(n172), .B(n165), .Y(n102) );
  NOR2X1 U160 ( .A(n170), .B(n164), .Y(n101) );
  NOR2X1 U161 ( .A(n170), .B(n169), .Y(n100) );
endmodule

