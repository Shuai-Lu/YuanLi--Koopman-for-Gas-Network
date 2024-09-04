function read_data(filename_eps, filename_ngs, flag_clear)
fprintf('%-40s\t\t', '- Reading data');
t0 = clock;
global data;

%% reading data ...
if ~flag_clear && exist([cd '\mydata.mat'], 'file')
    mydata = load('mydata.mat');
    data = mydata.data;
    clear mydata;
else
    % % test
    %  filename = 'testdata_6bus.xlsx';
    [sheet_bus, sheet_branch, sheet_gen, sheet_gencost, ...
        sheet_device, sheet_profile] = ...
        deal(1,2,3,4,5,6);
    data_bus = xlsread(filename_eps,sheet_bus);
    data_branch = xlsread(filename_eps,sheet_branch);
    data_gen = xlsread(filename_eps,sheet_gen);
    data_gencost = xlsread(filename_eps,sheet_gencost);
    data_device = xlsread(filename_eps,sheet_device);
    data_profile = xlsread(filename_eps,sheet_profile,'C4:BB1000');

    
    %%
    data.eps.bus = data_bus;
    data.eps.branch = data_branch;
    data.eps.gen = data_gen;
    data.eps.gencost = data_gencost;
    data.eps.device = data_device;

    %% profile P_load, Pwt
    indexset_elecload = find(data_profile(:,2)== 1); % 91 electrical load
    indexset_resload = find(data_profile(:,2) == 2); % wind power 10

    data.profile.bus_elecload = data_profile(indexset_elecload, 1);
    data.profile.bus_resload = data_profile(indexset_resload, 1);

    for i = 1 : size(indexset_elecload,1)
        data.profile.P_load(:,i) = data_profile(indexset_elecload(i,1), 3) * ...
            data_profile(indexset_elecload(i,1), 5:end)'*1;
    end
    for i = 1 : size(indexset_resload,1)
        resload(:,i) = data_profile(indexset_resload(i,1), 3) * ...
            data_profile(indexset_resload(i,1), 5:end)';
    end

    data.profile.Pwt = resload;

    indexset_gasload = find(data_profile(:,2)== 3);
    data.profile.bus_gasload = data_profile(indexset_gasload, 1);
    k=1;
    for i = 1:size(indexset_gasload,1)
        data.profile.M_load(:,i) = data_profile(indexset_gasload(i,1), 3) * ...
            data_profile(indexset_gasload(i,1), 5:end)'*k;

    end
 % data.profile.P_load =  data.profile.P_load';
    %% 20  NGN
    
    [sheet_pipe, sheet_node, sheet_source, sheet_compressor] = ...
        deal(1,2,3,4);
    data.ngs.pipe = xlsread(filename_ngs,sheet_pipe);
    data.ngs.node = xlsread(filename_ngs,sheet_node);
    data.ngs.source = xlsread(filename_ngs,sheet_source);
    data.ngs.compressor = xlsread(filename_ngs,sheet_compressor);

    %% loc
    %% ngs
    % pipe
    [data.loc.ngs.pipe.fnode, data.loc.ngs.pipe.tnode, data.loc.ngs.pipe.lamta, data.loc.ngs.pipe.Fmax, ...
        data.loc.ngs.pipe.Fmin, data.loc.ngs.pipe.diameter,  data.loc.ngs.pipe.length] = ...
        deal(1,2,3,4,5,6,7);
    % node
    [data.loc.ngs.node.ID, data.loc.ngs.node.type, data.loc.ngs.node.load, data.loc.ngs.node.Pmax, ...
        data.loc.ngs.node.Pmin, data.loc.ngs.node.P] = ...
        deal(1,2,3,4,5,6);
    % source
    [data.loc.ngs.source.nodeID, data.loc.ngs.source.Injection, data.loc.ngs.source.Pressure, ...
        data.loc.ngs.source.Fmax, data.loc.ngs.source.Fmin] = ...
        deal(1,2,3,4,5);
    % compressor
    [data.loc.ngs.compressor.nodeID, data.loc.ngs.compressor.pipe_in, ...
        data.loc.ngs.compressor.pipe_out, data.loc.ngs.compressor.ratio] = ...
        deal(1,2,3,4);
    


   
    %%    
    if  exist([cd '\mydata.mat'], 'file')
        delete('mydata.mat');
    end
    save('mydata.mat', 'data', '-v7');
end

%%
t1 = clock;
fprintf('%10.2f%s\n', etime(t1,t0), 's');

end