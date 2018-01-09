# MPproc
MP processing toolbox (Matlab)

To process a new MP deployment, copy [templates/MP_processing_worksheet.m](templates/MP_processing_worksheet.m) to your data directory and start from there.

The toolbox should contain all functions necessary to run the basic processing.

Despiking and CTDstruct were not adopted to new and modified routines and will probably not work out of the box. However, they should work after minor modifications as the structure of the output data has not changed.

Tilt correction for FSI ACM is now integrated. Use with caution as this has not been tested yet.

Happy processing!

Gunnar Voet
10/2015


NOTES ON FIXING CTD UP-DOWN OFFSETS
MMH 1/2018

To test parameters: In the MP worksheet, you can uncomment the lines starting with CTpar, play with the parameters, and run MP_test_CTD_params(info,profile_number) to find the combination of coefficients that  work best for a given instrument. 

The thermal mass correction uses alfa and beta, and fine-tuned using alfa2 and beta2. To turn off the fine turning, CTpar.alfa2 and CTpar.beta2 can both be set to 1 (or completely commented out).

Once you have the right settings, set the CTD calibration constants in cal/make_ctd_calfile_cruiseid_sn###.m

A good tutorial on Conductivity Cell Thermal Mass can be found at http://www.seabird.com/pdf_outside/Module12_AdvancedDataProcessing.pdf




