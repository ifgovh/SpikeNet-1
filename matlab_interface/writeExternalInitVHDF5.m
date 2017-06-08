function writeExternalInitVHDF5(FID,pop,exteral_init_V)
% write initial condition for membrane potential 
%            FID: file id for writing data
%            pop: is the number of population
% exteral_init_V: is the vector of initial membrane potential for all neurons
%                 of this population

hdf5write(FID,['/config/pops/pop',num2str(pop-1),'/SETINITV/exteral_init_V'],exteral_init_V,'WriteMode','append');   


    