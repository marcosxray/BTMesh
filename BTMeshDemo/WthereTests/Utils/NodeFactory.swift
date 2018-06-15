//
//  NodeFactory.swift
//  BTMesh
//
//  Created by Marcos Borges on 12/06/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import Foundation
import RxSwift
@testable import Wthere

class NodeFactory {
    
    static func generateNode_A() -> BTNode {
        let node = BTNode(name: "A", identifier: A_IDENTIFIER)
        
        let item_AB = BTRouteItem(targetNodeIdentifier: B_IDENTIFIER,
                                  escapeNodeIdentifier: A_IDENTIFIER,
                                  targetRssi: AB_RSSI,
                                  escapeRssi: 0,
                                  targetName: "B")
        
        let item_AC = BTRouteItem(targetNodeIdentifier: C_IDENTIFIER,
                                  escapeNodeIdentifier: A_IDENTIFIER,
                                  targetRssi: AC_RSSI,
                                  escapeRssi: 0,
                                  targetName: "C")
        
        let item_AD = BTRouteItem(targetNodeIdentifier: D_IDENTIFIER,
                                  escapeNodeIdentifier: A_IDENTIFIER,
                                  targetRssi: AD_RSSI,
                                  escapeRssi: 0,
                                  targetName: "D")
        
        let item_AE = BTRouteItem(targetNodeIdentifier: E_IDENTIFIER,
                                  escapeNodeIdentifier: A_IDENTIFIER,
                                  targetRssi: AE_RSSI,
                                  escapeRssi: 0,
                                  targetName: "E")
        
        let item_AF = BTRouteItem(targetNodeIdentifier: F_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: AC_RSSI + CF_RSSI,
                                  escapeRssi: AC_RSSI,
                                  targetName: "F")
        
        let item_AG = BTRouteItem(targetNodeIdentifier: G_IDENTIFIER,
                                  escapeNodeIdentifier: E_IDENTIFIER,
                                  targetRssi: AE_RSSI + EG_RSSI,
                                  escapeRssi: AE_RSSI,
                                  targetName: "G")
        
        let item_AH = BTRouteItem(targetNodeIdentifier: H_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: AC_RSSI + CH_RSSI,
                                  escapeRssi: AC_RSSI,
                                  targetName: "H")
        
        let item_AI = BTRouteItem(targetNodeIdentifier: I_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: AC_RSSI + CF_RSSI + FI_RSSI,
                                  escapeRssi: AC_RSSI,
                                  targetName: "I")
        
        node.visibleNodeItems.onNext([item_AB,
                                      item_AC,
                                      item_AD,
                                      item_AE,
                                      item_AF,
                                      item_AG,
                                      item_AH,
                                      item_AI])
        return node
    }

    static func generateNode_B() -> BTNode {
        let node = BTNode(name: "B", identifier: B_IDENTIFIER)
        
        let item_BA = BTRouteItem(targetNodeIdentifier: A_IDENTIFIER,
                                  escapeNodeIdentifier: B_IDENTIFIER,
                                  targetRssi: AB_RSSI,
                                  escapeRssi: 0,
                                  targetName: "A")
        
        let item_BC = BTRouteItem(targetNodeIdentifier: C_IDENTIFIER,
                                  escapeNodeIdentifier: B_IDENTIFIER,
                                  targetRssi: BC_RSSI,
                                  escapeRssi: 0,
                                  targetName: "C")
        
        let item_BF = BTRouteItem(targetNodeIdentifier: F_IDENTIFIER,
                                  escapeNodeIdentifier: B_IDENTIFIER,
                                  targetRssi: BF_RSSI,
                                  escapeRssi: 0,
                                  targetName: "F")
        
        let item_BD = BTRouteItem(targetNodeIdentifier: D_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: BC_RSSI + CD_RSSI,
                                  escapeRssi: BC_RSSI,
                                  targetName: "D")
        
        let item_BE = BTRouteItem(targetNodeIdentifier: E_IDENTIFIER,
                                  escapeNodeIdentifier: A_IDENTIFIER,
                                  targetRssi: BA_RSSI + AE_RSSI,
                                  escapeRssi: BA_RSSI,
                                  targetName: "E")

        let item_BG = BTRouteItem(targetNodeIdentifier: G_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: BC_RSSI + CG_RSSI,
                                  escapeRssi: BC_RSSI,
                                  targetName: "G")

        let item_BH = BTRouteItem(targetNodeIdentifier: H_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: BF_RSSI + FH_RSSI,
                                  escapeRssi: BF_RSSI,
                                  targetName: "H")
   
        let item_BI = BTRouteItem(targetNodeIdentifier: I_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: BF_RSSI + FI_RSSI,
                                  escapeRssi: BF_RSSI,
                                  targetName: "I")
        
        node.visibleNodeItems.onNext([item_BA,
                                      item_BC,
                                      item_BD,
                                      item_BE,
                                      item_BF,
                                      item_BG,
                                      item_BH,
                                      item_BI])
        
        return node
    }

    static func generateNode_C() -> BTNode {
        let node = BTNode(name: "C", identifier: C_IDENTIFIER)
        
        let item_CA = BTRouteItem(targetNodeIdentifier: A_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: CA_RSSI,
                                  escapeRssi: 0,
                                  targetName: "A")
        
        let item_CB = BTRouteItem(targetNodeIdentifier: B_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: CB_RSSI,
                                  escapeRssi: 0,
                                  targetName: "B")
        
        let item_CD = BTRouteItem(targetNodeIdentifier: D_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: CD_RSSI,
                                  escapeRssi: 0,
                                  targetName: "D")
        
        let item_CF = BTRouteItem(targetNodeIdentifier: F_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: CF_RSSI,
                                  escapeRssi: 0,
                                  targetName: "F")
        
        let item_CG = BTRouteItem(targetNodeIdentifier: G_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: CG_RSSI,
                                  escapeRssi: 0,
                                  targetName: "G")
        
        let item_CH = BTRouteItem(targetNodeIdentifier: H_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: CH_RSSI,
                                  escapeRssi: 0,
                                  targetName: "H")
        
        let item_CE = BTRouteItem(targetNodeIdentifier: E_IDENTIFIER,
                                  escapeNodeIdentifier: A_IDENTIFIER,
                                  targetRssi: CA_RSSI + AE_RSSI,
                                  escapeRssi: CA_RSSI,
                                  targetName: "E")
     
        let item_CI = BTRouteItem(targetNodeIdentifier: I_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: CF_RSSI + FI_RSSI,
                                  escapeRssi: CF_RSSI,
                                  targetName: "I")
        
        node.visibleNodeItems.onNext([item_CB,
                                      item_CA,
                                      item_CD,
                                      item_CE,
                                      item_CF,
                                      item_CG,
                                      item_CH,
                                      item_CI])
        
        return node
    }

    static func generateNode_D() -> BTNode {
        let node = BTNode(name: "D", identifier: D_IDENTIFIER)
        
        let item_DA = BTRouteItem(targetNodeIdentifier: A_IDENTIFIER,
                                  escapeNodeIdentifier: D_IDENTIFIER,
                                  targetRssi: DA_RSSI,
                                  escapeRssi: 0,
                                  targetName: "A")
        
        let item_DC = BTRouteItem(targetNodeIdentifier: C_IDENTIFIER,
                                  escapeNodeIdentifier: D_IDENTIFIER,
                                  targetRssi: DC_RSSI,
                                  escapeRssi: 0,
                                  targetName: "C")
        
        let item_DE = BTRouteItem(targetNodeIdentifier: E_IDENTIFIER,
                                  escapeNodeIdentifier: D_IDENTIFIER,
                                  targetRssi: DE_RSSI,
                                  escapeRssi: 0,
                                  targetName: "E")
        
        let item_DG = BTRouteItem(targetNodeIdentifier: G_IDENTIFIER,
                                  escapeNodeIdentifier: D_IDENTIFIER,
                                  targetRssi: DG_RSSI,
                                  escapeRssi: 0,
                                  targetName: "G")
        
        let item_DB = BTRouteItem(targetNodeIdentifier: B_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: DC_RSSI + CB_RSSI,
                                  escapeRssi: DC_RSSI,
                                  targetName: "B")
        
        let item_DF = BTRouteItem(targetNodeIdentifier: F_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: DC_RSSI + CF_RSSI,
                                  escapeRssi: DC_RSSI,
                                  targetName: "F")
        
        let item_DH = BTRouteItem(targetNodeIdentifier: H_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: DC_RSSI + CH_RSSI,
                                  escapeRssi: DC_RSSI,
                                  targetName: "H")
        
        let item_DI = BTRouteItem(targetNodeIdentifier: I_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: DG_RSSI + GI_RSSI,
                                  escapeRssi: DG_RSSI,
                                  targetName: "I")
        
        node.visibleNodeItems.onNext([item_DA,
                                      item_DC,
                                      item_DE,
                                      item_DG,
                                      item_DB,
                                      item_DF,
                                      item_DH,
                                      item_DI])
        
        return node
    }

    static func generateNode_E() -> BTNode {
        let node = BTNode(name: "E", identifier: E_IDENTIFIER)
        
        let item_EA = BTRouteItem(targetNodeIdentifier: A_IDENTIFIER,
                                  escapeNodeIdentifier: E_IDENTIFIER,
                                  targetRssi: EA_RSSI,
                                  escapeRssi: 0,
                                  targetName: "A")
        
        let item_ED = BTRouteItem(targetNodeIdentifier: D_IDENTIFIER,
                                  escapeNodeIdentifier: E_IDENTIFIER,
                                  targetRssi: ED_RSSI,
                                  escapeRssi: 0,
                                  targetName: "D")
        
        let item_EG = BTRouteItem(targetNodeIdentifier: G_IDENTIFIER,
                                  escapeNodeIdentifier: E_IDENTIFIER,
                                  targetRssi: EG_RSSI,
                                  escapeRssi: 0,
                                  targetName: "G")
        
        let item_EC = BTRouteItem(targetNodeIdentifier: C_IDENTIFIER,
                                  escapeNodeIdentifier: A_IDENTIFIER,
                                  targetRssi: EA_RSSI + AC_RSSI,
                                  escapeRssi: EA_RSSI,
                                  targetName: "C")
        
        let item_EB = BTRouteItem(targetNodeIdentifier: B_IDENTIFIER,
                                  escapeNodeIdentifier: A_IDENTIFIER,
                                  targetRssi: EA_RSSI + AB_RSSI,
                                  escapeRssi: EA_RSSI,
                                  targetName: "B")
        
        let item_EF = BTRouteItem(targetNodeIdentifier: F_IDENTIFIER,
                                  escapeNodeIdentifier: A_IDENTIFIER,
                                  targetRssi: EA_RSSI + AC_RSSI + CF_RSSI,
                                  escapeRssi: EA_RSSI,
                                  targetName: "F")
        
        let item_EH = BTRouteItem(targetNodeIdentifier: H_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: EG_RSSI + GH_RSSI,
                                  escapeRssi: EG_RSSI,
                                  targetName: "H")

        let item_EI = BTRouteItem(targetNodeIdentifier: I_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: EG_RSSI + GI_RSSI,
                                  escapeRssi: EG_RSSI,
                                  targetName: "I")
        
        node.visibleNodeItems.onNext([item_EA,
                                      item_ED,
                                      item_EG,
                                      item_EC,
                                      item_EB,
                                      item_EF,
                                      item_EH,
                                      item_EI])
        
        return node
    }
    
    static func generateNode_F() -> BTNode {
        let node = BTNode(name: "F", identifier: F_IDENTIFIER)
        
        let item_FB = BTRouteItem(targetNodeIdentifier: B_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: FB_RSSI,
                                  escapeRssi: 0,
                                  targetName: "B")
        
        let item_FC = BTRouteItem(targetNodeIdentifier: C_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: FC_RSSI,
                                  escapeRssi: 0,
                                  targetName: "C")
        
        let item_FH = BTRouteItem(targetNodeIdentifier: H_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: FH_RSSI,
                                  escapeRssi: 0,
                                  targetName: "H")
        
        let item_FI = BTRouteItem(targetNodeIdentifier: I_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: FI_RSSI,
                                  escapeRssi: 0,
                                  targetName: "I")
        
        let item_FA = BTRouteItem(targetNodeIdentifier: A_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: FC_RSSI + CA_RSSI,
                                  escapeRssi: FC_RSSI,
                                  targetName: "A")
        
        let item_FD = BTRouteItem(targetNodeIdentifier: D_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: FC_RSSI + CD_RSSI,
                                  escapeRssi: FC_RSSI,
                                  targetName: "D")
        
        let item_FG = BTRouteItem(targetNodeIdentifier: G_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: FC_RSSI + CG_RSSI,
                                  escapeRssi: FC_RSSI,
                                  targetName: "G")

        let item_FE = BTRouteItem(targetNodeIdentifier: F_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: FC_RSSI + CA_RSSI + AE_RSSI,
                                  escapeRssi: FC_RSSI,
                                  targetName: "E")
        
        node.visibleNodeItems.onNext([item_FB,
                                      item_FC,
                                      item_FH,
                                      item_FI,
                                      item_FA,
                                      item_FD,
                                      item_FG,
                                      item_FE])
        
        return node
    }

    static func generateNode_G() -> BTNode {
        let node = BTNode(name: "G", identifier: G_IDENTIFIER)
        
        let item_GC = BTRouteItem(targetNodeIdentifier: C_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: GC_RSSI,
                                  escapeRssi: 0,
                                  targetName: "C")
        
        let item_GD = BTRouteItem(targetNodeIdentifier: D_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: GD_RSSI,
                                  escapeRssi: 0,
                                  targetName: "D")
        
        let item_GE = BTRouteItem(targetNodeIdentifier: E_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: GE_RSSI,
                                  escapeRssi: 0,
                                  targetName: "E")
        
        let item_GH = BTRouteItem(targetNodeIdentifier: H_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: GH_RSSI,
                                  escapeRssi: 0,
                                  targetName: "H")
        
        let item_GI = BTRouteItem(targetNodeIdentifier: I_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: GI_RSSI,
                                  escapeRssi: 0,
                                  targetName: "I")
     
        let item_GB = BTRouteItem(targetNodeIdentifier: B_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: GC_RSSI + CB_RSSI,
                                  escapeRssi: GC_RSSI,
                                  targetName: "B")
        
        let item_GA = BTRouteItem(targetNodeIdentifier: A_IDENTIFIER,
                                  escapeNodeIdentifier: E_IDENTIFIER,
                                  targetRssi: GE_RSSI + EA_RSSI,
                                  escapeRssi: GE_RSSI,
                                  targetName: "A")
      
        let item_GF = BTRouteItem(targetNodeIdentifier: F_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: GC_RSSI + CF_RSSI,
                                  escapeRssi: GC_RSSI,
                                  targetName: "F")
        
        node.visibleNodeItems.onNext([item_GC,
                                      item_GD,
                                      item_GE,
                                      item_GH,
                                      item_GI,
                                      item_GB,
                                      item_GA,
                                      item_GF])
        
        return node
    }
    
    static func generateNode_H() -> BTNode {
        let node = BTNode(name: "H", identifier: H_IDENTIFIER)
        
        let item_HC = BTRouteItem(targetNodeIdentifier: C_IDENTIFIER,
                                  escapeNodeIdentifier: H_IDENTIFIER,
                                  targetRssi: HC_RSSI,
                                  escapeRssi: 0,
                                  targetName: "C")
        
        let item_HG = BTRouteItem(targetNodeIdentifier: G_IDENTIFIER,
                                  escapeNodeIdentifier: H_IDENTIFIER,
                                  targetRssi: HG_RSSI,
                                  escapeRssi: 0,
                                  targetName: "G")
        
        let item_HF = BTRouteItem(targetNodeIdentifier: F_IDENTIFIER,
                                  escapeNodeIdentifier: H_IDENTIFIER,
                                  targetRssi: HF_RSSI,
                                  escapeRssi: 0,
                                  targetName: "F")
        
        let item_HI = BTRouteItem(targetNodeIdentifier: I_IDENTIFIER,
                                  escapeNodeIdentifier: H_IDENTIFIER,
                                  targetRssi: HI_RSSI,
                                  escapeRssi: 0,
                                  targetName: "I")
        
        let item_HD = BTRouteItem(targetNodeIdentifier: D_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: HC_RSSI + CD_RSSI,
                                  escapeRssi: HC_RSSI,
                                  targetName: "D")
        
        let item_HE = BTRouteItem(targetNodeIdentifier: E_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: HG_RSSI + GE_RSSI,
                                  escapeRssi: HG_RSSI,
                                  targetName: "E")
        
        let item_HB = BTRouteItem(targetNodeIdentifier: B_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: HF_RSSI + FB_RSSI,
                                  escapeRssi: HF_RSSI,
                                  targetName: "B")
        
        let item_HA = BTRouteItem(targetNodeIdentifier: A_IDENTIFIER,
                                  escapeNodeIdentifier: C_IDENTIFIER,
                                  targetRssi: HC_RSSI + CA_RSSI,
                                  escapeRssi: HC_RSSI,
                                  targetName: "A")
        
        node.visibleNodeItems.onNext([item_HC,
                                      item_HG,
                                      item_HF,
                                      item_HI,
                                      item_HD,
                                      item_HE,
                                      item_HB,
                                      item_HA])
        
        return node
    }

    static func generateNode_I() -> BTNode {
        let node = BTNode(name: "I", identifier: I_IDENTIFIER)
        
        let item_IH = BTRouteItem(targetNodeIdentifier: H_IDENTIFIER,
                                  escapeNodeIdentifier: I_IDENTIFIER,
                                  targetRssi: IH_RSSI,
                                  escapeRssi: 0,
                                  targetName: "H")
        
        let item_IG = BTRouteItem(targetNodeIdentifier: G_IDENTIFIER,
                                  escapeNodeIdentifier: I_IDENTIFIER,
                                  targetRssi: IG_RSSI,
                                  escapeRssi: 0,
                                  targetName: "G")
        
        let item_IF = BTRouteItem(targetNodeIdentifier: F_IDENTIFIER,
                                  escapeNodeIdentifier: I_IDENTIFIER,
                                  targetRssi: IF_RSSI,
                                  escapeRssi: 0,
                                  targetName: "F")
        
        let item_IC = BTRouteItem(targetNodeIdentifier: C_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: FI_RSSI + FC_RSSI,
                                  escapeRssi: FI_RSSI,
                                  targetName: "C")
        
        let item_ID = BTRouteItem(targetNodeIdentifier: D_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: IG_RSSI + GD_RSSI,
                                  escapeRssi: IG_RSSI,
                                  targetName: "D")
        
        let item_IE = BTRouteItem(targetNodeIdentifier: E_IDENTIFIER,
                                  escapeNodeIdentifier: G_IDENTIFIER,
                                  targetRssi: IG_RSSI + GE_RSSI,
                                  escapeRssi: IG_RSSI,
                                  targetName: "E")
        
        let item_IB = BTRouteItem(targetNodeIdentifier: B_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: FI_RSSI + FB_RSSI,
                                  escapeRssi: FI_RSSI,
                                  targetName: "B")
    
        let item_IA = BTRouteItem(targetNodeIdentifier: A_IDENTIFIER,
                                  escapeNodeIdentifier: F_IDENTIFIER,
                                  targetRssi: FI_RSSI + FB_RSSI + BA_RSSI,
                                  escapeRssi: FI_RSSI,
                                  targetName: "A")
        
        node.visibleNodeItems.onNext([item_IH,
                                      item_IG,
                                      item_IF,
                                      item_IC,
                                      item_ID,
                                      item_IE,
                                      item_IB,
                                      item_IA])
        
        return node
    }
}
