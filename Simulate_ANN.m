function Simulate_ANN (features)

load('DATA_VFE.mat')
load('NETWORKS_VFE.mat')
a = netALL54(features');
[v_a, i_a] = max(a);

i_a

end