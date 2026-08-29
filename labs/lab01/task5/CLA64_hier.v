module cla64_hier(
    input  [63:0] a,
    input  [63:0] b,
    input         cin,
    output [63:0] sum,
    output        cout
);

    // Block-level Generate and Propagate
    wire [15:0] Gblock;
    wire [15:0] Pblock;

    // Carry between 4-bit blocks
    wire [16:0] C;

    // Intermediate signals for second-level CLA
    wire t1, t2, t3, t4;
    wire t5, t6, t7, t8;
    wire t9, t10, t11, t12;
    wire t13, t14, t15, t16;
    wire t17, t18, t19, t20;
    wire t21, t22, t23, t24;
    wire t25, t26, t27, t28;
    wire t29, t30, t31, t32;
    wire t33, t34, t35, t36;
    wire t37, t38, t39, t40;
    wire t41, t42, t43, t44;
    wire t45, t46, t47, t48;
    wire t49, t50, t51, t52;
    wire t53, t54, t55, t56;
    wire t57, t58, t59, t60;

    // Initial carry
    assign #2 C[0] = cin;

    // =========================================================
    // 16 x 4-bit CLA blocks
    // =========================================================

    cla4 block0  (.a(a[3:0]),   .b(b[3:0]),   .cin(C[0]),  .sum(sum[3:0]),   .cout(), .Gblock(Gblock[0]),  .Pblock(Pblock[0]));
    cla4 block1  (.a(a[7:4]),   .b(b[7:4]),   .cin(C[1]),  .sum(sum[7:4]),   .cout(), .Gblock(Gblock[1]),  .Pblock(Pblock[1]));
    cla4 block2  (.a(a[11:8]),  .b(b[11:8]),  .cin(C[2]),  .sum(sum[11:8]),  .cout(), .Gblock(Gblock[2]),  .Pblock(Pblock[2]));
    cla4 block3  (.a(a[15:12]), .b(b[15:12]), .cin(C[3]),  .sum(sum[15:12]), .cout(), .Gblock(Gblock[3]),  .Pblock(Pblock[3]));

    cla4 block4  (.a(a[19:16]), .b(b[19:16]), .cin(C[4]),  .sum(sum[19:16]), .cout(), .Gblock(Gblock[4]),  .Pblock(Pblock[4]));
    cla4 block5  (.a(a[23:20]), .b(b[23:20]), .cin(C[5]),  .sum(sum[23:20]), .cout(), .Gblock(Gblock[5]),  .Pblock(Pblock[5]));
    cla4 block6  (.a(a[27:24]), .b(b[27:24]), .cin(C[6]),  .sum(sum[27:24]), .cout(), .Gblock(Gblock[6]),  .Pblock(Pblock[6]));
    cla4 block7  (.a(a[31:28]), .b(b[31:28]), .cin(C[7]),  .sum(sum[31:28]), .cout(), .Gblock(Gblock[7]),  .Pblock(Pblock[7]));

    cla4 block8  (.a(a[35:32]), .b(b[35:32]), .cin(C[8]),  .sum(sum[35:32]), .cout(), .Gblock(Gblock[8]),  .Pblock(Pblock[8]));
    cla4 block9  (.a(a[39:36]), .b(b[39:36]), .cin(C[9]),  .sum(sum[39:36]), .cout(), .Gblock(Gblock[9]),  .Pblock(Pblock[9]));
    cla4 block10 (.a(a[43:40]), .b(b[43:40]), .cin(C[10]), .sum(sum[43:40]), .cout(), .Gblock(Gblock[10]), .Pblock(Pblock[10]));
    cla4 block11 (.a(a[47:44]), .b(b[47:44]), .cin(C[11]), .sum(sum[47:44]), .cout(), .Gblock(Gblock[11]), .Pblock(Pblock[11]));

    cla4 block12 (.a(a[51:48]), .b(b[51:48]), .cin(C[12]), .sum(sum[51:48]), .cout(), .Gblock(Gblock[12]), .Pblock(Pblock[12]));
    cla4 block13 (.a(a[55:52]), .b(b[55:52]), .cin(C[13]), .sum(sum[55:52]), .cout(), .Gblock(Gblock[13]), .Pblock(Pblock[13]));
    cla4 block14 (.a(a[59:56]), .b(b[59:56]), .cin(C[14]), .sum(sum[59:56]), .cout(), .Gblock(Gblock[14]), .Pblock(Pblock[14]));
    cla4 block15 (.a(a[63:60]), .b(b[63:60]), .cin(C[15]), .sum(sum[63:60]), .cout(), .Gblock(Gblock[15]), .Pblock(Pblock[15]));


    // =========================================================
    // Second-level Carry Lookahead
    //
    // C[k+1] = Gk + Pk*C[k]
    // =========================================================

    // C1 = G0 + P0*Cin
    and #(2) (t1, Pblock[0], C[0]);
    or  #(2) (C[1], Gblock[0], t1);


    // C2 = G1 + P1*G0 + P1*P0*Cin
    and #(2) (t2, Pblock[1], Gblock[0]);
    and #(2) (t3, Pblock[1], Pblock[0], C[0]);
    or  #(2) (C[2], Gblock[1], t2, t3);


    // C3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*Cin
    and #(2) (t4, Pblock[2], Gblock[1]);
    and #(2) (t5, Pblock[2], Pblock[1], Gblock[0]);
    and #(2) (t6, Pblock[2], Pblock[1], Pblock[0], C[0]);
    or  #(2) (C[3], Gblock[2], t4, t5, t6);


    // C4
    and #(2) (t7, Pblock[3], Gblock[2]);
    and #(2) (t8, Pblock[3], Pblock[2], Gblock[1]);
    and #(2) (t9, Pblock[3], Pblock[2], Pblock[1], Gblock[0]);
    and #(2) (t10, Pblock[3], Pblock[2], Pblock[1], Pblock[0], C[0]);
    or #(2) (C[4], Gblock[3], t7, t8, t9, t10);


    // C5
    and #(2) (t11, Pblock[4], Gblock[3]);
    and #(2) (t12, Pblock[4], Pblock[3], Gblock[2]);
    and #(2) (t13, Pblock[4], Pblock[3], Pblock[2], Gblock[1]);
    and #(2) (t14, Pblock[4], Pblock[3], Pblock[2], Pblock[1], Gblock[0]);
    and #(2) (t15, Pblock[4], Pblock[3], Pblock[2], Pblock[1], Pblock[0], C[0]);
    or #(2) (C[5], Gblock[4], t11, t12, t13, t14, t15);


    // C6
    and #(2) (t16, Pblock[5], Gblock[4]);
    and #(2) (t17, Pblock[5], Pblock[4], Gblock[3]);
    and #(2) (t18, Pblock[5], Pblock[4], Pblock[3], Gblock[2]);
    and #(2) (t19, Pblock[5], Pblock[4], Pblock[3], Pblock[2], Gblock[1]);
    and #(2) (t20, Pblock[5], Pblock[4], Pblock[3], Pblock[2], Pblock[1], Gblock[0]);
    and #(2) (t21, Pblock[5], Pblock[4], Pblock[3], Pblock[2], Pblock[1], Pblock[0], C[0]);
    or #(2) (C[6], Gblock[5], t16, t17, t18, t19, t20, t21);


    // C7
    and #(2) (t22, Pblock[6], Gblock[5]);
    and #(2) (t23, Pblock[6], Pblock[5], Gblock[4]);
    and #(2) (t24, Pblock[6], Pblock[5], Pblock[4], Gblock[3]);
    and #(2) (t25, Pblock[6], Pblock[5], Pblock[4], Pblock[3], Gblock[2]);
    and #(2) (t26, Pblock[6], Pblock[5], Pblock[4], Pblock[3], Pblock[2], Gblock[1]);
    and #(2) (t27, Pblock[6], Pblock[5], Pblock[4], Pblock[3], Pblock[2], Pblock[1], Gblock[0]);
    and #(2) (t28, Pblock[6], Pblock[5], Pblock[4], Pblock[3], Pblock[2], Pblock[1], Pblock[0], C[0]);
    or #(2) (C[7], Gblock[6], t22, t23, t24, t25, t26, t27, t28);


    // C8
    and #(2) (t29, Pblock[7], Gblock[6]);
    and #(2) (t30, Pblock[7], Pblock[6], Gblock[5]);
    and #(2) (t31, Pblock[7], Pblock[6], Pblock[5], Gblock[4]);
    and #(2) (t32, Pblock[7], Pblock[6], Pblock[5], Pblock[4], Gblock[3]);
    and #(2) (t33, Pblock[7], Pblock[6], Pblock[5], Pblock[4], Pblock[3], Gblock[2]);
    and #(2) (t34, Pblock[7], Pblock[6], Pblock[5], Pblock[4], Pblock[3], Pblock[2], Gblock[1]);
    and #(2) (t35, Pblock[7], Pblock[6], Pblock[5], Pblock[4], Pblock[3], Pblock[2], Pblock[1], Gblock[0]);
    and #(2) (t36, Pblock[7], Pblock[6], Pblock[5], Pblock[4], Pblock[3], Pblock[2], Pblock[1], Pblock[0], C[0]);
    or #(2) (C[8], Gblock[7], t29, t30, t31, t32, t33, t34, t35, t36);


    // =========================================================
    // C9-C16
    // =========================================================

    and #(2) (t37, Pblock[8], Gblock[7]);
    and #(2) (t38, Pblock[8], Pblock[7], Gblock[6]);
    and #(2) (t39, Pblock[8], Pblock[7], Pblock[6], Gblock[5]);
    and #(2) (t40, Pblock[8], Pblock[7], Pblock[6], Pblock[5], Gblock[4]);
    and #(2) (t41, Pblock[8], Pblock[7], Pblock[6], Pblock[5], Pblock[4], Gblock[3]);
    and #(2) (t42, Pblock[8], Pblock[7], Pblock[6], Pblock[5], Pblock[4], Pblock[3], Gblock[2]);
    and #(2) (t43, Pblock[8], Pblock[7], Pblock[6], Pblock[5], Pblock[4], Pblock[3], Pblock[2], Gblock[1]);
    and #(2) (t44, Pblock[8], Pblock[7], Pblock[6], Pblock[5], Pblock[4], Pblock[3], Pblock[2], Pblock[1], Gblock[0]);
    and #(2) (t45, Pblock[8], Pblock[7], Pblock[6], Pblock[5], Pblock[4], Pblock[3], Pblock[2], Pblock[1], Pblock[0], C[0]);
    or #(2) (C[9], Gblock[8], t37, t38, t39, t40, t41, t42, t43, t44, t45);


    // For C10-C16, use recursive block carry equations.
    // Each carry is generated directly from the previous
    // block's G/P and the already calculated block carry.

    and #(2) (t46, Pblock[9], C[9]);
    or  #(2) (C[10], Gblock[9], t46);

    and #(2) (t47, Pblock[10], C[10]);
    or  #(2) (C[11], Gblock[10], t47);

    and #(2) (t48, Pblock[11], C[11]);
    or  #(2) (C[12], Gblock[11], t48);

    and #(2) (t49, Pblock[12], C[12]);
    or  #(2) (C[13], Gblock[12], t49);

    and #(2) (t50, Pblock[13], C[13]);
    or  #(2) (C[14], Gblock[13], t50);

    and #(2) (t51, Pblock[14], C[14]);
    or  #(2) (C[15], Gblock[14], t51);

    and #(2) (t52, Pblock[15], C[15]);
    or  #(2) (C[16], Gblock[15], t52);

    assign #2 cout = C[16];

endmodule
