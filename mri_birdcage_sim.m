function [B1p, B1n,sigmaH] = mri_birdcage_sim (model_parameters)
%% %%%%%%%%%%%%%%%%%%%%% Initializing COMSOL %%%%%%%%%%%%%%%%%%%%%
tstart=tic;
clc;
fprintf('| Creating birdcage coil geometry');
fprintf('| \n');
import com.comsol.model.*
import com.comsol.model.util.*
model = ModelUtil.create('Model');
%Model defination dimension, study type
model.modelNode.create('comp1');
model.geom.create('geom1', 3);
model.mesh.create('mesh1', 'geom1');
model.physics.create('emw', 'ElectromagneticWaves', 'geom1');
model.study.create('std1');
model.study('std1').create('freq', 'Frequency');
model.study('std1').feature('freq').activate('emw', true);
model.geom('geom1').label('coil model');
model.geom('geom1').run;

if model_parameters.Ncoil  == 4
    model_parameters.delete_entities  = [1,4,5,6,7,8,9,10,12,14,15,16,17,23,24,25,26,27,28,29,30,31,32,33,39,40,...
        42,43,44,45,46,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,64,71,77,78,79,80];
    model_parameters.coil      = [9,10,11,12,14,16,33,35,40,41,52,53,67,69,72,74];
elseif model_parameters.Ncoil  == 8
    model_parameters.delete_entities  = [1,4,5,6,7,8,9,10,12,14,15,16,17,23,24,25,26,27,28,29,30,31,32,38,39,50,51,52,...
        54,55,56,57,58,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,76,88,89,100,101,102,103,104];
    model_parameters.coil      = [9 10 11 12 14 16 19 21 38 40 43 45 50 51 62 63 77 79 82 84 87 89 92 94];
elseif model_parameters.Ncoil  == 16
    model_parameters.delete_entities  = [1,4,5,7,8,9,10,17,18,19,20,21,22,28,29,30,31,32,33,34,35,36,37,43,44,55,56,67,68,74,...
        76,77,79,84,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,102,104,115,116,127,128,139,140,141,142,143];
    model_parameters.coil      = [9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,52,53,54,55,56,57,...
        58,59,60,61,62,63,64,65,66,70,71,72,73,74,75,76,87,88,101,102,103,104,105,106,107,108,109,110,111,...
        112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135];
else
end
%% Make outer structure of the coil
model.geom('geom1').create('cyl1', 'Cylinder');
model.geom('geom1').feature('cyl1').label('Outer_ring');
model.geom('geom1').feature('cyl1').set('r', model_parameters.r_coil);
model.geom('geom1').feature('cyl1').set('h', model_parameters.h_coil);
model.geom('geom1').run('cyl1');
position = [0, 0, -model_parameters.h_coil/2];
model.geom('geom1').feature('cyl1').set('pos', position);
model.geom('geom1').feature('cyl1').setIndex('layer',model_parameters.t_ring, 0);
model.geom('geom1').feature('cyl1').set('layerbottom', 'on');
model.geom('geom1').feature('cyl1').set('layertop', 'on');
model.geom('geom1').run('cyl1');
%% Make rungs
model.geom('geom1').feature.create('wp1', 'WorkPlane');
model.geom('geom1').feature('wp1').set('unite', true);
model.geom('geom1').feature('wp1').set('quickz', position(3)+model_parameters.t_ring');
model.geom('geom1').feature('wp1').geom.create('c1', 'Circle');
model.geom('geom1').feature('wp1').geom.feature('c1').set('r', model_parameters.r_coil);
model.geom('geom1').feature('wp1').geom.feature('c1').set('angle', '6');
model.geom('geom1').feature('wp1').geom.feature('c1').set('rot', '-22.5');
model.geom('geom1').feature('wp1').geom.run('c1');
model.geom('geom1').feature('wp1').geom.create('ccur1', 'ConvertToCurve');
model.geom('geom1').feature('wp1').geom.feature('ccur1').selection('input').set({'c1'});
model.geom('geom1').feature('wp1').geom.run('ccur1');

model.geom('geom1').feature('wp1').geom.run('ccur1');
model.geom('geom1').feature('wp1').geom.create('del1', 'Delete');
model.geom('geom1').feature('wp1').geom.feature('del1').selection('input').set('ccur1', [2 3]);
model.geom('geom1').run('wp1');

model.geom('geom1').feature.create('ext1', 'Extrude');
model.geom('geom1').feature('ext1').setIndex('distance', model_parameters.h_coil-2*model_parameters.t_ring', 0);
model.geom('geom1').feature('ext1').set('unite', 'off');
model.geom('geom1').run('ext1');

model.geom('geom1').feature.create('ext2', 'Extrude');
model.geom('geom1').feature('ext2').setIndex('distance', model_parameters.l_element, 0);
model.geom('geom1').run('ext2');

model.geom('geom1').create('mov1', 'Move');
model.geom('geom1').feature('mov1').selection('input').set({'ext2'});
Move_cord = [0 (model_parameters.h_coil-2*model_parameters.t_ring)/2-model_parameters.l_element/2 (model_parameters.h_coil-2*model_parameters.t_ring)-model_parameters.l_element];
model.geom('geom1').feature('mov1').set('displz', Move_cord);
model.geom('geom1').run('mov1');

model.geom('geom1').create('rot1', 'Rotate');
model.geom('geom1').feature('rot1').selection('input').set({'ext1' 'mov1'});
model.geom('geom1').feature('rot1').set('pos', {'0' '0' '0'});
model.geom('geom1').feature('rot1').set('rot', model_parameters.Nrings);
model.geom('geom1').run('rot1');
model.geom('geom1').run('rot1');
model.geom('geom1').create('csur1', 'ConvertToSurface');
model.geom('geom1').feature('csur1').selection('input').set({'cyl1' 'rot1'});
model.geom('geom1').run('fin');
% Delete the remaining entities
model.geom('geom1').create('del1', 'Delete');
model.geom('geom1').feature('del1').selection('input').set('csur1', model_parameters.delete_entities);
model.geom('geom1').run('del1');
fprintf('| birdcage coil geometry created');
fprintf('| \n');
%% Make sheild and calculations domains
model.geom('geom1').create('cyl2', 'Cylinder');
model.geom('geom1').feature('cyl2').set('r', model_parameters.r_coil-0.09);
model.geom('geom1').feature('cyl2').set('h', model_parameters.h_coil);
model.geom('geom1').feature('cyl2').setIndex('layer', model_parameters.h_coil/2, 0);
model.geom('geom1').feature('cyl2').set('pos', position); clear position;
model.geom('geom1').feature('cyl2').set('layerside', 'off');
model.geom('geom1').feature('cyl2').set('layertop', 'on');
model.geom('geom1').run('cyl2');
model.geom('geom1').create('cyl3', 'Cylinder');
model.geom('geom1').feature('cyl3').set('r', model_parameters.r_coil+0.1);
model.geom('geom1').feature('cyl3').set('h', model_parameters.h_coil+0.1);
position = [0, 0, -model_parameters.h_coil+0.2/2];
model.geom('geom1').feature('cyl3').set('pos', position);
model.geom('geom1').run('cyl3');
model.geom('geom1').create('sph1', 'Sphere');
model.geom('geom1').feature('sph1').set('r', '0.5');
model.geom('geom1').run('fin');
fprintf('| Outer shield created ');
fprintf('| \n');
%% Make phantom inside as a object
model.geom('geom1').feature('fin').set('repairtol', '2.0E-9');
model.geom('geom1').create('cyl4', 'Cylinder');
model.geom('geom1').feature('cyl4').label('Phantom');
model.geom('geom1').feature('cyl4').set('r', model_parameters.r_coil/2);
model.geom('geom1').feature('cyl4').set('h', model_parameters.h_coil);
position = [0, 0, -model_parameters.h_coil/2];
model.geom('geom1').feature('cyl4').set('pos', position);clear position;
model.geom('geom1').run('cyl4');
model.geom('geom1').create('cyl5', 'Cylinder');
model.geom('geom1').feature('cyl5').set('r', model_parameters.r_coil/5);
model.geom('geom1').feature('cyl5').set('h', model_parameters.h_coil/3);
% position = [0.05, 0, -model_parameters.h_coil/2];
position = [0.05, 0, -0.05];
model.geom('geom1').feature('cyl5').set('pos', position);
model.geom('geom1').run('cyl5'); clear position;
model.geom('geom1').feature('cyl5').label('Anomaly');
model.geom('geom1').run('fin');
fprintf('| Phantom object -- Added ');
fprintf('| \n');
%% Create a set of selections to be used when setting up the physics.
%First, create a selection for the coil surfaces
%coil
model.selection.create('sel1', 'Explicit');
model.selection('sel1').label('Coil');
model.selection('sel1').geom(2);
model.selection('sel1').set(model_parameters.coil);
%Add a selection for the edges around the coil to evaluate the average field
model.selection.create('sel2', 'Explicit');
model.selection('sel2').label('Circle');
model.selection('sel2').geom(1);

if model_parameters.Ncoil  == 4
    model.selection('sel2').set([42 43 87 106]);
elseif model_parameters.Ncoil  == 8
    model.selection('sel2').set([60 61 123 142]);
elseif model_parameters.Ncoil  == 16
    model.selection('sel2').set([112 113 195 214]);
else
end
model.selection('sel2').set('groupcontang', true);

%Add a selection for the absorbing boundaries surrounding the model domain
model.selection.create('sel3', 'Explicit');
model.selection('sel3').label('Absorbing boudnaries');
model.selection('sel3').geom(2);

if model_parameters.Ncoil  == 4
    model.selection('sel3').set([1 2 3 4 37 38 46 47 57]);
elseif model_parameters.Ncoil  == 8
    model.selection('sel3').set([1 2 3 4 48 49 57 58]);
elseif model_parameters.Ncoil  == 16
    model.selection('sel3').set([1 2 3 4 67 68 81 82]);
else
end
model.selection('sel3').set('groupcontang', true);
%Define the operators to evaluate the average field around the coil.
model.cpl.create('aveop1', 'Average', 'geom1');
model.cpl('aveop1').selection.geom('geom1', 1);
model.cpl('aveop1').selection.named('sel2');
model.cpl.create('intop1', 'Integration', 'geom1');
model.cpl('intop1').selection.geom('geom1', 1);
model.cpl('intop1').selection.named('sel2');
%Variables 1
model.variable.create('var1');
model.variable('var1').model('comp1');
model.variable('var1').set('Bleft', 'abs(emw.Bx+j*emw.By)', 'Left hand rotating component of magnetic flux');
model.variable('var1').set('Bright', 'abs(emw.Bx-j*emw.By)', 'Right hand rotating component of magnetic flux');
model.variable('var1').set('BaxialratiodB', '20*log10((Bright+Bleft)/(Bright-Bleft))', 'Magnetic flux axial ratio');
model.variable('var1').set('intBaxialratiodB', 'intop1(abs(BaxialratiodB))', 'Integration of magnetic flux circularity around the phantom');
model.variable('var1').set('stdev', 'sqrt(aveop1(emw.normE^2)-aveop1(emw.normE)^2)', 'Standard deviation of E norm');
fprintf('| Interpolating Domain Property ');
fprintf('| \n');
%Use the material properties of air for all the domains in the model.
model.material.create('mat1', 'Common', 'comp1');
model.material('mat1').propertyGroup('def').set('electricconductivity', {'0'});
model.material('mat1').propertyGroup('def').set('relpermeability', {'1'});
model.material('mat1').propertyGroup('def').set('relpermittivity', {'1'});
model.material.create('mat2', 'Common', 'comp1');
model.material('mat2').selection.set([5 6]);
model.material('mat2').propertyGroup('def').set('electricconductivity', {'0.5'});
model.material('mat2').propertyGroup('def').set('relpermeability', {'1'});
model.material('mat2').propertyGroup('def').set('relpermittivity', {'1'});
model.material.create('mat3', 'Common', 'comp1');
model.material('mat3').selection.set([7 8]);
model.material('mat3').propertyGroup('def').set('electricconductivity', {'2'});
model.material('mat3').propertyGroup('def').set('relpermeability', {'1'});
model.material('mat3').propertyGroup('def').set('relpermittivity', {'1'});
fprintf('| Domain Property -- Added ');
fprintf('| \n');
%% Boundary condition
fprintf('| Domain condition -- Adding ');
fprintf('| \n');
fprintf('| \n');
model.physics('emw').feature.create('pec2', 'PerfectElectricConductor', 2);
model.physics('emw').feature('pec2').selection.named('sel1');
model.physics('emw').feature.create('pec3', 'PerfectElectricConductor', 2);

if model_parameters.Ncoil  == 4
    model.physics('emw').feature('pec3').selection.set([5 6 39 54]);
elseif model_parameters.Ncoil  == 8
    model.physics('emw').feature('pec3').selection.set([5 6 49 64]);
elseif model_parameters.Ncoil  == 16
    model.physics('emw').feature('pec3').selection.set([5,6,69,89]);
else
end

if model_parameters.Ncoil  == 4
    model.physics('emw').feature.create('lport1', 'LumpedPort', 2);
    model.physics('emw').feature('lport1').set('PortExcitation', 'on');
    model.physics('emw').feature('lport1').set('V0', 200);
    model.physics('emw').feature('lport1').selection.set(73);
    model.physics('emw').feature.create('lport2', 'LumpedPort', 2);
    model.physics('emw').feature('lport2').selection.set(68);
    model.physics('emw').feature('lport2').set('PortExcitation', 'on');
    model.physics('emw').feature('lport2').set('V0', 200);
    model.physics('emw').feature('lport2').set('Thetap', 'pi/2');
    
    port = [15 34 75 70 17 36 71 66 13 32];
    
elseif model_parameters.Ncoil  == 8
    model.physics('emw').feature.create('lport1', 'LumpedPort', 2);
    model.physics('emw').feature('lport1').set('PortExcitation', 'on');
    model.physics('emw').feature('lport1').set('V0', 200);
    model.physics('emw').feature('lport1').selection.set(83);
    model.physics('emw').feature.create('lport2', 'LumpedPort', 2);
    model.physics('emw').feature('lport2').selection.set(88);
    model.physics('emw').feature('lport2').set('PortExcitation', 'on');
    model.physics('emw').feature('lport2').set('V0', 200);
    model.physics('emw').feature('lport2').set('Thetap', 'pi/2');
    
    port = [93 78 39 15 20 44 81 91 86 76 37 13 18 42 85 95 90 80 41 17 22 46];
    
elseif  model_parameters.Ncoil  == 16
    
    model.physics('emw').feature.create('lport1', 'LumpedPort', 2);
    model.physics('emw').feature('lport1').set('PortExcitation', 'on');
    model.physics('emw').feature('lport1').set('V0', 200);
    model.physics('emw').feature('lport1').selection.set(108);
    model.physics('emw').feature.create('lport2', 'LumpedPort', 2);
    model.physics('emw').feature('lport2').selection.set(123);
    model.physics('emw').feature('lport2').set('PortExcitation', 'on');
    model.physics('emw').feature('lport2').set('V0', 200);
    model.physics('emw').feature('lport2').set('Thetap', 'pi/2');
    
    port = [118,128,133,113,103,64,54,30,20,13,25,35,59,73,...
        110,120,130,135,125,115,105,66,56,32,22,15,27,37,61,75,...
        71,106,116,126,131,121,111,101,62,52,28,18,11,23,33,57];
    
end

ctr  = 1;
for ii = 1:size(port,2)
    name = ['lelement',num2str(ii)];
    model.physics('emw').feature.create(name, 'LumpedElement', 2);
    model.physics('emw').feature(name).selection.set(port(ii));
    model.physics('emw').feature(name).set('LumpedElementType', 'Capacitor');
    model.physics('emw').feature(name).set('Celement', model_parameters.c_value);
    ctr = ctr+1;
end

model.physics('emw').feature.create('sctr1', 'Scattering', 2);
model.physics('emw').feature('sctr1').selection.named('sel3');
fprintf('| Domain condition -- Added ');
fprintf('| \n');
%% Model design parameters
if model_parameters.f0  == 64;
    model.study('std1').feature('freq').set('plist', '63.87[MHz]');
elseif  model_parameters.f0  == 128;
    model.study('std1').feature('freq').set('plist', '127.74[MHz]');
elseif model_parameters.f0  == 300;
    model.study('std1').feature('freq').set('plist', '295.2[MHz]');
else
end
model.param.set('c_value', model_parameters.c_value);
model.param.set('r_coil', model_parameters.r_coil);
model.param.set('h_coil', model_parameters.h_coil);
model.param.set('l_element', model_parameters.l_element);

model.mesh('mesh1').autoMeshSize(4);
model.mesh('mesh1').run;

fprintf('| Creating model solution ');
fprintf('| \n');

if model_parameters.parametricS == 1
    fprintf('| \n');
    model.study('std1').create('param', 'Parametric');
    model.study('std1').feature('param').setIndex('pname', 'c_value', 0);
    model.study('std1').feature('param').setIndex('punit', 'pF', 0);
    model.study('std1').feature('param').setIndex('plistarr', 'range(10,0.5,30)', 0);
    
    model.sol.create('sol1');
    model.sol('sol1').study('std1');
    model.study('std1').feature('freq').set('notlistsolnum', 1);
    model.study('std1').feature('freq').set('notsolnum', 'auto');
    model.study('std1').feature('freq').set('listsolnum', 1);
    model.study('std1').feature('freq').set('solnum', 'auto');
    
    model.sol('sol1').create('st1', 'StudyStep');
    model.sol('sol1').feature('st1').set('study', 'std1');
    model.sol('sol1').feature('st1').set('studystep', 'freq');
    model.sol('sol1').create('v1', 'Variables');
    model.sol('sol1').feature('v1').set('control', 'freq');
    model.sol('sol1').create('s1', 'Stationary');
    model.sol('sol1').feature('s1').set('stol', 0.01);
    model.sol('sol1').feature('s1').create('p1', 'Parametric');
    model.sol('sol1').feature('s1').feature('p1').set('pname', 'c_value');
    model.sol('sol1').feature('s1').feature('p1').set('plistarr', 'range(10,0.5,30)');
    model.sol('sol1').feature('s1').feature('p1').set('punit', 'pF');
    model.sol('sol1').feature('s1').feature('p1').set('sweeptype', 'sparse');
    model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'no');
    model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
    model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
    model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'Default');
    model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
    model.sol('sol1').feature('s1').feature('p1').set('probes', []);
    model.sol('sol1').feature('s1').feature('p1').set('control', 'param');
    model.sol('sol1').feature('s1').set('control', 'freq');
    model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
    model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
    model.sol('sol1').feature('s1').create('i1', 'Iterative');
    model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'gmres');
    model.sol('sol1').feature('s1').feature('i1').set('prefuntype', 'right');
    model.sol('sol1').feature('s1').feature('i1').set('itrestart', '300');
    model.sol('sol1').feature('s1').feature('i1').label('Suggested Iterative Solver (emw)');
    model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('iter', '1');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').create('sv1', 'SORVector');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', 'comp1_E');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').create('sv1', 'SORVector');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', 'comp1_E');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
    model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
    model.sol('sol1').feature('s1').feature.remove('fcDef');
    model.sol('sol1').attach('std1');
    model.sol('sol1').runAll;
else
    model.sol.create('sol1');
    model.sol('sol1').study('std1');
    
    model.study('std1').feature('freq').set('notlistsolnum', 1);
    model.study('std1').feature('freq').set('notsolnum', '1');
    model.study('std1').feature('freq').set('listsolnum', 1);
    model.study('std1').feature('freq').set('solnum', '1');
    
    model.sol('sol1').create('st1', 'StudyStep');
    model.sol('sol1').feature('st1').set('study', 'std1');
    model.sol('sol1').feature('st1').set('studystep', 'freq');
    model.sol('sol1').create('v1', 'Variables');
    model.sol('sol1').feature('v1').set('control', 'freq');
    model.sol('sol1').create('s1', 'Stationary');
    model.sol('sol1').feature('s1').create('p1', 'Parametric');
    model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
    
    if model_parameters.f0  == 64;
        model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'63.87[MHz]'});
    elseif  model_parameters.f0  == 128;
        model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'127.74[MHz]'});
    elseif model_parameters.f0  == 300;
        model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'295.2[MHz]'});      
    else
    end
    
    model.sol('sol1').feature('s1').feature('p1').set('punit', {'Hz'});
    model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
    model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
    model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
    model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'Default');
    model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
    model.sol('sol1').feature('s1').feature('p1').set('probes', {});
    model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
    model.sol('sol1').feature('s1').set('control', 'freq');
    model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
    model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
    model.sol('sol1').feature('s1').create('i1', 'Iterative');
    model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
    model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').create('sv1', 'SORVector');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').create('sv1', 'SORVector');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
    model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
    model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
    model.sol('sol1').feature('s1').feature.remove('fcDef');
    model.sol('sol1').attach('std1');
    model.sol('sol1').runAll;
end

tend=toc(tstart);
fprintf('| \n');
disp(['| Done simulating birdcage coil. Runtime: ' datestr(tend/(24*60*60), 'DD:HH:MM:SS.FFF')]);
fprintf('===============================================================\n');
%% %%%%%%% Post-process the data over a "mesh" for multiple slices %%%%%%%%%
imSize  = model_parameters.imSize;  FOV  = model_parameters.FOV;
nSlices = model_parameters.Nslices; ht = model_parameters.ht;
x       = -FOV/2+(0:imSize-1)*(FOV/imSize);
y       = -FOV/2+(0:imSize-1)*(FOV/imSize);  y = rot90(y,1);
z       = -ht/nSlices+(0:nSlices-1)*(ht/nSlices);
% z       = (0:nSlices-1)*(ht/nSlices);
[X,Y,Z] = meshgrid(x,y,z);
xx      = [X(:),Y(:),Z(:)]';
clear x y z X Y Z;
%%%%%% COMSOL solution for transversal component of conductivity %%%%%
roi = mphinterp(model,'emw.sigmaxx','coord',xx,'edim','domain','ext',0);
roi(isnan(roi)|isinf(roi)) = 0; roi = roi(1,:);
sigmaH = reshape(roi,imSize,imSize,nSlices);
roi    = reshape(roi,imSize,imSize,nSlices);roi = double(roi~=0);
fprintf('| \n');
fprintf('Calculating complex B+ and B- field');

Bx     = mphinterp(model,'emw.Bx','coord',xx,'edim','domain','ext',0);
By     = mphinterp(model,'emw.By','coord',xx,'edim','domain','ext',0);
Bx(isnan(Bx)|isinf(Bx)) = 0; Bx = Bx(1,:);
By(isnan(By)|isinf(By)) = 0; By = By(1,:);
Bx = reshape(Bx,imSize,imSize,nSlices); Bx = Bx.*roi;
By = reshape(By,imSize,imSize,nSlices); By = By.*roi;
B1p  = Bx+(1i*By)/2;  B1n  = Bx-(1i*By)/2; clc;
fprintf('DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
end