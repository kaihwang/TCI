#!/bin/bash
# get FC and MTD maps, separatly for TTD and TDSigEI

### TTD
TTD_data='/home/despoB/kaihwang/TRSE/TTD/Results/'
TD_data='/home/despoB/kaihwang/TRSE/TDSigEI'
w=15
dset=V1

for contrast in BC_FH_FFA BC_HF_PPA MTD_FH_FFA-VC MTD_HF_FFA-VC; do 

	#### TTD
	echo "cd /home/despoB/kaihwang/TRSE/TCI/Group 
	3dMEMA -prefix /home/despoB/kaihwang/TRSE/TCI/Group/TTD_${contrast}_w${w}_groupMEMA \\
	-set ${contrast} \\" > /home/despoB/kaihwang/TRSE/TCI/Group/TTD_${dset}_${contrast}_${w}.sh

	cd ${TTD_data}
	
	for s in sub-7002 sub-7003 sub-7004 sub-7006 sub-7008 sub-7009 sub-7012 sub-7014 sub-7016 sub-7017 sub-7019; do 

		if [ -e ${TTD_data}/${s}/ses-Loc/MTD_BC_stats_w${w}_MNI_${dset}_REML+orig.HEAD ]; then
			cbrik=$(3dinfo -verb ${TTD_data}/${s}//ses-Loc/MTD_BC_stats_w${w}_MNI_${dset}_REML+orig | grep "${contrast}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
			tbrik=$(3dinfo -verb ${TTD_data}/${s}//ses-Loc/MTD_BC_stats_w${w}_MNI_${dset}_REML+orig | grep "${contrast}#0_Tstat" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')

			echo "${s} ${TTD_data}/${s}//ses-Loc/MTD_BC_stats_w${w}_MNI_${dset}_REML+orig[${cbrik}] ${TTD_data}/${s}//ses-Loc/MTD_BC_stats_w${w}_MNI_${dset}_REML+orig[${tbrik}] \\" >> /home/despoB/kaihwang/TRSE/TCI/Group/TTD_${dset}_${contrast}_${w}.sh
		fi
	done

	for s in sub-7018 sub-7021 sub-7022 sub-7024 sub-7025 sub-7026 sub-7027 sub-6601 sub-6602 sub-6603 sub-6605 sub-6617; do #diff ver of fmriprep gave diff header
		
		if [ -e ${TTD_data}/${s}/ses-Loc/MTD_BC_stats_w${w}_MNI_${dset}_REML+tlrc.HEAD ]; then
			cbrik=$(3dinfo -verb ${TTD_data}/${s}//ses-Loc/MTD_BC_stats_w${w}_MNI_${dset}_REML+tlrc | grep "${contrast}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
			tbrik=$(3dinfo -verb ${TTD_data}/${s}//ses-Loc/MTD_BC_stats_w${w}_MNI_${dset}_REML+tlrc | grep "${contrast}#0_Tstat" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')

			echo "${s} ${TTD_data}/${s}//ses-Loc/MTD_BC_stats_w${w}_MNI_${dset}_REML+tlrc[${cbrik}] ${TTD_data}/${s}//ses-Loc/MTD_BC_stats_w${w}_MNI_${dset}_REML+tlrc[${tbrik}] \\" >> /home/despoB/kaihwang/TRSE/TCI/Group/TTD_${dset}_${contrast}_${w}.sh
		fi
	done

	echo "-cio -mask /home/despoB/kaihwang/TRSE/TTD/Group/overlap_mask.nii.gz" >> /home/despoB/kaihwang/TRSE/TCI/Group/TTD_${dset}_${contrast}_${w}.sh

	qsub -l mem_free=3.5G -V -M kaihwang -m e -e ~/tmp -o ~/tmp /home/despoB/kaihwang/TRSE/TCI/Group/TTD_${dset}_${contrast}_${w}.sh



	#### TDSigEI
	echo "cd /home/despoB/kaihwang/TRSE/TCI/Group 
	3dMEMA -prefix /home/despoB/kaihwang/TRSE/TCI/Group/TD_${contrast}_w${w}_groupMEMA \\
	-set ${contrast} \\" > /home/despoB/kaihwang/TRSE/TCI/Group/TD_${dset}_${contrast}_${w}.sh

	cd ${TD_data}
	
	for s in $(/bin/ls -d 5*); do 

		if [ -e ${TD_data}/${s}/FIR_w15_MTDperm_BC_stats_REML+tlrc.HEAD ]; then
			cbrik=$(3dinfo -verb ${TD_data}/${s}/FIR_w15_MTDperm_BC_stats_REML+tlrc | grep "${contrast}#0_Coef" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')
			tbrik=$(3dinfo -verb ${TD_data}/${s}/FIR_w15_MTDperm_BC_stats_REML+tlrc | grep "${contrast}#0_Tstat" | grep -o ' #[0-9]\{1,3\}' | grep -o '[0-9]\{1,3\}')

			echo "${s} ${TD_data}/${s}/FIR_w15_MTDperm_BC_stats_REML+tlrc[${cbrik}] ${TD_data}/${s}/FIR_w15_MTDperm_BC_stats_REML+tlrc[${tbrik}] \\" >> /home/despoB/kaihwang/TRSE/TCI/Group/TD_${dset}_${contrast}_${w}.sh
		fi
	done

	echo "-cio -mask /home/despoB/kaihwang/TRSE/TDSigEI/ROIs/100overlap_mask+tlrc" >> /home/despoB/kaihwang/TRSE/TCI/Group/TD_${dset}_${contrast}_${w}.sh

	qsub -l mem_free=3.5G -V -M kaihwang -m e -e ~/tmp -o ~/tmp /home/despoB/kaihwang/TRSE/TCI/Group/TD_${dset}_${contrast}_${w}.sh


	cd /home/despoB/kaihwang/TRSE/TCI/Group/

done

