# Unit tests
All unit tests for BTRouter were done based on the following hypothetical model:
</br></br>
<img src="https://github.com/marcosxray/BTMesh/blob/master/Docs/mesh_model.png">
</br></br>
The values between each node correspond to the RSSI in that segment.
</br>
The current implementation of BTMesh uses the RSSI value as its main metric to define a viable path.
</br></br>

# Validating the model
The previous model can be validated in the linear programming software <a href="https://www.lindo.com">LINDO</a>.
As an example, the following simulation model can be used to determine the best path from node "A" to node "I":
</br></br>
! Go or not from point "i" to point "j",
</br>
! Where i={A,B,C,D,E,F,G,H} and j={B,C,D,E,F,G,H,I}
</br>
! The "ij" value can be zero or one;
</br></br>
MIN	
</br>
65AB + 75AE + 80AC + 92AD + 90ED + 75CD +
</br>
76BC + 77BF + 53CF + 91CH + 84CG + 94DG +
</br>
87EG + 79FH + 80GH + 81FI + 85HI + 91GI
</br>
ST
</br>
	AB + AC + AD + AE = 1
  </br>
	FI + HI + GI = 1
  </br>
	AB + CB + FB - BC - BF = 0
  </br>
	BC + AC + FC + HC + GC + DC - CB - CF - CH - CG - CD = 0
  </br>
	AD + CD + ED + GD - DC - DE - DG = 0
  </br>
	AE + DE + GE - ED - EG = 0
  </br>
	BF + CF + HF - FB - FC - FH - FI = 0
  </br>
	FH + CH + GH - HF - HC - HG - HI = 0 
  </br>
	CG + DG + EG + HG - GC - GD - GE - GH - GI = 0
  </br>
END
</br>
INT 29
