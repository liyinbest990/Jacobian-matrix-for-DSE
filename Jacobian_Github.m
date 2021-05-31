% syms w_mea V_mea  % measured w and V
% syms P2_mea Q2_mea % measured P and Q of BESS 2

% syms E1 E2 E3 % measured energy of three BESSs
% syms P0_bes1 P0_bes2 P0_bes3 % P references of three BESSs
% syms w0_bes1 w0_bes2 w0_bes3 % w references of three BESSs
% syms Q0_bes1 Q0_bes2 Q0_bes3 % Q references of three BESSs
% syms V0_bes1 V0_bes2 V0_bes3 % V references of three BESSs

% syms wb T_tao Ratio_EP % base frequency; time constant of power electronic device; EP ratio
% syms Rf Lf Cf % measured energy of three BESSs
% syms m n Kpi Kii Kpp Kip Kpq Kiq % gains of droop control
% syms C1 C2 C3 C4 C5 % consensus gains
% syms P_load Q_load % power of load
% syms id iq uc_d uc_q Md Mq Nd Nq % variables of circuit of BESS 2

jaco=...
[  0, -1/Ratio_EP, -m/Ratio_EP,   0,           0,     0,               0,                 0,                0,                  0,   0,           0,           0,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
 -C1,         -C2,       -C2*m,   0,           0,    C1,              C2,              C2*m,                0,                  0,   0,           0,           0,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,         -C3, - C3 - C3*m,   0,           0,     0,              C3,         C3 + C3*m,                0,                  0,   0,           0,           0,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0, -C4,       -C4*n,     0,               0,                 0,               C4,               C4*n,   0,           0,           0,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0, -C5, - C5 - C5*n,     0,               0,                 0,               C5,          C5 + C5*n,   0,           0,           0,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0,   0,           0,     0,     -1/Ratio_EP,       -m/Ratio_EP,                0,                  0,   0,           0,           0,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
  C1,          C2,        C2*m,   0,           0, -2*C1,           -2*C2,           -2*C2*m,                0,                  0,  C1,          C2,        C2*m,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,          C3,   C3 + C3*m,   0,           0,     0,           -2*C3,   - 2*C3 - 2*C3*m,                0,                  0,   0,          C3,   C3 + C3*m,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0,  C4,        C4*n,     0,               0,                 0,            -2*C4,            -2*C4*n,   0,           0,           0,  C4,        C4*n,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0,  C5,   C5 + C5*n,     0,               0,                 0,            -2*C5,    - 2*C5 - 2*C5*n,   0,           0,           0,  C5,   C5 + C5*n,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0,   0,           0,     0,               0,                 0,                0,                  0,   0, -1/Ratio_EP, -m/Ratio_EP,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0,   0,           0,    C1,              C2,              C2*m,                0,                  0, -C1,         -C2,       -C2*m,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0,   0,           0,     0,              C3,         C3 + C3*m,                0,                  0,   0,         -C3, - C3 - C3*m,   0,           0,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0,   0,           0,     0,               0,                 0,               C4,               C4*n,   0,           0,           0, -C4,       -C4*n,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0,   0,           0,     0,               0,                 0,               C5,          C5 + C5*n,   0,           0,           0, -C5, - C5 - C5*n,                                   0,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0,   0,           0,     0,               0,                 0,                0,                  0,   0,           0,           0,   0,           0,                              -Rf/Lf,                                  wb,     1/Lf,        0,       0,       0,         0,         0;
   0,           0,           0,   0,           0,     0,               0,                 0,                0,                  0,   0,           0,           0,   0,           0,                                 -wb,                              -Rf/Lf,        0,     1/Lf,       0,       0,         0,         0;
   0,           0,           0,   0,           0,     0, (Kpi*Kpp)/T_tao, (Kpi*Kpp*m)/T_tao,                0,                  0,   0,           0,           0,   0,           0, - Kpi/T_tao - (Kpi*Kpp*V_mea)/T_tao,                      -(Lf*wb)/T_tao, -1/T_tao,        0, 1/T_tao,       0, Kpi/T_tao,         0;
   0,           0,           0,   0,           0,     0,               0,                 0, -(Kpi*Kpq)/T_tao, -(Kpi*Kpq*n)/T_tao,   0,           0,           0,   0,           0,                       (Lf*wb)/T_tao, - Kpi/T_tao - (Kpi*Kpq*V_mea)/T_tao,        0, -1/T_tao,       0, 1/T_tao,         0, Kpi/T_tao;
   0,           0,           0,   0,           0,     0,         Kii*Kpp,         Kii*Kpp*m,                0,                  0,   0,           0,           0,   0,           0,                -Kii*(Kpp*V_mea + 1),                                   0,        0,        0,       0,       0,       Kii,         0;
   0,           0,           0,   0,           0,     0,               0,                 0,         -Kii*Kpq,         -Kii*Kpq*n,   0,           0,           0,   0,           0,                                   0,                -Kii*(Kpq*V_mea + 1),        0,        0,       0,       0,         0,       Kii;
   0,           0,           0,   0,           0,     0,             Kip,             Kip*m,                0,                  0,   0,           0,           0,   0,           0,                          -Kip*V_mea,                                   0,        0,        0,       0,       0,         0,         0;
   0,           0,           0,   0,           0,     0,               0,                 0,             -Kiq,             -Kiq*n,   0,           0,           0,   0,           0,                                   0,                          -Kiq*V_mea,        0,        0,       0,       0,         0,         0];
 
 H=...
 [0,0,0,0,0, 1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,0,0,0; 
  0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 1,0,0,0,0,0,0,0];

 
