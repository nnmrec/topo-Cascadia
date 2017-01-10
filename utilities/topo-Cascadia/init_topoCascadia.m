function OPTIONS = init_topoCascadia(OPTIONS)

%% setup the case directory, where any newly generated files will be stored
OPTIONS.dir_case = ['cases' filesep OPTIONS.casename];

mkdir(OPTIONS.dir_case);


