if retrieveMethod == "samely"
    switch i
        
        case 1
            B_d1 = readtable("LateralForceBump_d1_LH.csv"); D_d1 = readtable("LateralForceDent_d1_LH.csv"); B=B_d1; D=D_d1;
        case 2
            B_d2 = readtable("LateralForceBump_d2_LH.csv"); D_d2 = readtable("LateralForceDent_d2_LH.csv"); B=B_d2; D=D_d2; 
        case 3
            B_d3 = readtable("LateralForceBump_d3_LH.csv"); D_d3 = readtable("LateralForceDent_d3_LH.csv"); B=B_d3; D=D_d3;
        case 4
            B_e1 = readtable("LateralForceBump_e1_LH.csv"); D_e1 = readtable("LateralForceDent_e1_LH.csv"); B=B_e1; D=D_e1;
        case 5
            B_e2 = readtable("LateralForceBump_e2_LH.csv"); D_e2 = readtable("LateralForceDent_e2_LH.csv"); B=B_e2; D=D_e2;
        case 6
            B_e3 = readtable("LateralForceBump_e3_LH.csv"); D_e3 = readtable("LateralForceDent_e3_LH.csv"); B=B_e3; D=D_e3;
        case 7
            B_f1 = readtable("LateralForceBump_f1_LH.csv"); D_f1 = readtable("LateralForceDent_f1_LH.csv"); B=B_f1; D=D_f1;
        case 8
            B_f2 = readtable("LateralForceBump_f2_LH.csv"); D_f2 = readtable("LateralForceDent_f2_LH.csv"); B=B_f2; D=D_f2;
        case 9
            B_f3 = readtable("LateralForceBump_f3_LH.csv"); D_f3 = readtable("LateralForceDent_f3_LH.csv"); B=B_f3; D=D_f3;

    end



elseif retrieveMethod == "separately"

    switch i
        
        case 1
            B_d1 = readtable("LateralForceBump_d1_LH.csv"); B=B_d1;
        case 2
            D_d1 = readtable("LateralForceDent_d1_LH.csv"); D=D_d1;
        case 3
            B_d2 = readtable("LateralForceBump_d2_LH.csv"); B=B_d2;
        case 4
            D_d2 = readtable("LateralForceDent_d2_LH.csv"); D=D_d2; 
        case 5
            B_d3 = readtable("LateralForceBump_d3_LH.csv"); B=B_d3;
        case 6
            D_d3 = readtable("LateralForceDent_d3_LH.csv"); D=D_d3;
        case 7
            B_e1 = readtable("LateralForceBump_e1_LH.csv"); B=B_e1;
        case 8
            D_e1 = readtable("LateralForceDent_e1_LH.csv"); D=D_e1;
        case 9
            B_e2 = readtable("LateralForceBump_e2_LH.csv"); B=B_e2;
        case 10
            D_e2 = readtable("LateralForceDent_e2_LH.csv"); D=D_e2;
        case 11
            B_e3 = readtable("LateralForceBump_e3_LH.csv"); B=B_e3;
        case 12
            D_e3 = readtable("LateralForceDent_e3_LH.csv"); D=D_e3;
        case 13
            B_f1 = readtable("LateralForceBump_f1_LH.csv"); B=B_f1;
        case 14
            D_f1 = readtable("LateralForceDent_f1_LH.csv"); D=D_f1;
        case 15
            B_f2 = readtable("LateralForceBump_f2_LH.csv"); B=B_f2;
        case 16
            D_f2 = readtable("LateralForceDent_f2_LH.csv"); D=D_f2;
        case 17
            B_f3 = readtable("LateralForceBump_f3_LH.csv"); B=B_f3;
        case 18
            D_f3 = readtable("LateralForceDent_f3_LH.csv"); D=D_f3;

    end
end


