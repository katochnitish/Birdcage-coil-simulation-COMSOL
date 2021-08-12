function out = model
%
% mri_coil.m
%
% Model exported on Jul 21 2021, 14:13 by COMSOL 5.6.0.341.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('C:\Users\Sajib\Dropbox\birdcage coil model');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 3);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('emw', 'ElectromagneticWaves', 'geom1');

model.study.create('std1');
model.study('std1').create('freq', 'Frequency');
model.study('std1').feature('freq').set('solnum', 'auto');
model.study('std1').feature('freq').set('notsolnum', 'auto');
model.study('std1').feature('freq').activate('emw', true);

model.component('comp1').geom('geom1').run;

model.study('std1').feature('freq').set('plist', '63.87[MHz]');

model.param.set('c_value', '10[pF]');
model.param.descr('c_value', 'Capacitance used on the rungs');
model.param.set('r_coil', '0.24[m]');
model.param.descr('r_coil', 'Radius of the coil');
model.param.set('h_coil', '0.3[m]');
model.param.descr('h_coil', 'Height of the coil');
model.param.set('l_element', '0.01[m]');
model.param.descr('l_element', 'Length of the capacitive elements');

model.component('comp1').geom('geom1').insertFile('mri_coil_geom_sequence.mph', 'geom1');
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').view('view1').set('renderwireframe', true);

model.component('comp1').geom('geom1').run('sph1');
model.component('comp1').geom('geom1').create('imp1', 'Import');
model.component('comp1').geom('geom1').feature('imp1').set('filename', 'mri_coil.mphbin');
model.component('comp1').geom('geom1').feature('fin').set('repairtoltype', 'absolute');
model.component('comp1').geom('geom1').feature('fin').set('absrepairtol', 2.0E-9);
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').selection.create('sel1', 'Explicit');
model.component('comp1').selection('sel1').label('Coil');
model.component('comp1').selection('sel1').geom(2);
model.component('comp1').selection('sel1').set([9 10 11 12 14 16 19 21 31 33 36 38 66 67 76 77 85 87 90 92 95 97 100 102]);
model.component('comp1').selection.create('sel2', 'Explicit');
model.component('comp1').selection('sel2').label('Circle');
model.component('comp1').selection('sel2').geom(1);
model.component('comp1').selection('sel2').set([61]);
model.component('comp1').selection('sel2').set('groupcontang', true);
model.component('comp1').selection.create('sel3', 'Explicit');
model.component('comp1').selection('sel3').label('Absorbing boundaries');
model.component('comp1').selection('sel3').geom(2);
model.component('comp1').selection('sel3').set([4]);
model.component('comp1').selection('sel3').set('groupcontang', true);

model.component('comp1').cpl.create('aveop1', 'Average');
model.component('comp1').cpl('aveop1').set('axisym', true);
model.component('comp1').cpl('aveop1').selection.geom('geom1', 1);
model.component('comp1').cpl('aveop1').selection.named('sel2');
model.component('comp1').cpl.create('intop1', 'Integration');
model.component('comp1').cpl('intop1').set('axisym', true);
model.component('comp1').cpl('intop1').selection.geom('geom1', 1);
model.component('comp1').cpl('intop1').selection.named('sel2');

model.component('comp1').variable.create('var1');
model.component('comp1').variable('var1').set('Bleft', 'abs(emw.Bx+j*emw.By)');
model.component('comp1').variable('var1').descr('Bleft', 'Left hand rotating component of magnetic flux');
model.component('comp1').variable('var1').set('Bright', 'abs(emw.Bx-j*emw.By)');
model.component('comp1').variable('var1').descr('Bright', 'Right hand rotating component of magnetic flux');
model.component('comp1').variable('var1').set('BaxialratiodB', '20*log10((Bright+Bleft)/(Bright-Bleft))');
model.component('comp1').variable('var1').descr('BaxialratiodB', 'Magnetic flux axial ratio');
model.component('comp1').variable('var1').set('intBaxialratiodB', 'intop1(abs(BaxialratiodB))');
model.component('comp1').variable('var1').descr('intBaxialratiodB', 'Integration of magnetic flux circularity around the phantom');
model.component('comp1').variable('var1').set('stdev', 'sqrt(aveop1(emw.normE^2)-aveop1(emw.normE)^2)');
model.component('comp1').variable('var1').descr('stdev', 'Standard deviation of E norm');

model.component('comp1').view('view1').hideEntities.create('hide1');
model.component('comp1').view('view1').hideEntities('hide1').geom('geom1', 2);
model.component('comp1').view('view1').hideEntities('hide1').set([1 2 3 4 5 8 23 26 29 63 64 65 68 69 70 71]);

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'1'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1'});
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'0'});

model.component('comp1').physics('emw').create('pec2', 'PerfectElectricConductor', 2);
model.component('comp1').physics('emw').feature('pec2').selection.named('sel1');
model.component('comp1').physics('emw').create('pec3', 'PerfectElectricConductor', 2);
model.component('comp1').physics('emw').feature('pec3').selection.set([5 6 65 78]);
model.component('comp1').physics('emw').create('lport1', 'LumpedPort', 2);
model.component('comp1').physics('emw').feature('lport1').selection.set([37]);
model.component('comp1').physics('emw').feature('lport1').set('V0', 200);
model.component('comp1').physics('emw').create('lport2', 'LumpedPort', 2);
model.component('comp1').physics('emw').feature('lport2').selection.set([101]);
model.component('comp1').physics('emw').feature('lport2').set('PortExcitation', 'on');
model.component('comp1').physics('emw').feature('lport2').set('V0', 200);
model.component('comp1').physics('emw').feature('lport2').set('Thetap', 'pi/2');
model.component('comp1').physics('emw').create('lelement1', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement1').selection.set([91]);
model.component('comp1').physics('emw').feature('lelement1').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement1').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement2', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement2').selection.set([96]);
model.component('comp1').physics('emw').feature('lelement2').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement2').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement3', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement3').selection.set([86]);
model.component('comp1').physics('emw').feature('lelement3').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement3').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement4', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement4').selection.set([32]);
model.component('comp1').physics('emw').feature('lelement4').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement4').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement5', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement5').selection.set([15]);
model.component('comp1').physics('emw').feature('lelement5').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement5').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement6', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement6').selection.set([20]);
model.component('comp1').physics('emw').feature('lelement6').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement6').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement7', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement7').selection.set([35]);
model.component('comp1').physics('emw').feature('lelement7').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement7').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement8', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement8').selection.set([89]);
model.component('comp1').physics('emw').feature('lelement8').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement8').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement9', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement9').selection.set([99]);
model.component('comp1').physics('emw').feature('lelement9').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement9').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement10', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement10').selection.set([94]);
model.component('comp1').physics('emw').feature('lelement10').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement10').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement11', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement11').selection.set([84]);
model.component('comp1').physics('emw').feature('lelement11').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement11').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement12', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement12').selection.set([30]);
model.component('comp1').physics('emw').feature('lelement12').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement12').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement13', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement13').selection.set([13]);
model.component('comp1').physics('emw').feature('lelement13').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement13').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement14', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement14').selection.set([18]);
model.component('comp1').physics('emw').feature('lelement14').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement14').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement15', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement15').selection.set([39]);
model.component('comp1').physics('emw').feature('lelement15').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement15').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement16', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement16').selection.set([93]);
model.component('comp1').physics('emw').feature('lelement16').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement16').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement17', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement17').selection.set([103]);
model.component('comp1').physics('emw').feature('lelement17').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement17').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement18', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement18').selection.set([98]);
model.component('comp1').physics('emw').feature('lelement18').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement18').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement19', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement19').selection.set([88]);
model.component('comp1').physics('emw').feature('lelement19').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement19').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement20', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement20').selection.set([34]);
model.component('comp1').physics('emw').feature('lelement20').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement20').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement21', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement21').selection.set([17]);
model.component('comp1').physics('emw').feature('lelement21').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement21').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('lelement22', 'LumpedElement', 2);
model.component('comp1').physics('emw').feature('lelement22').selection.set([22]);
model.component('comp1').physics('emw').feature('lelement22').set('LumpedElementType', 'Capacitor');
model.component('comp1').physics('emw').feature('lelement22').set('Celement', 'c_value');
model.component('comp1').physics('emw').create('sctr1', 'Scattering', 2);
model.component('comp1').physics('emw').feature('sctr1').selection.named('sel3');

model.study('std1').create('param', 'Parametric');
model.study('std1').feature('param').setIndex('pname', 'c_value', 0);
model.study('std1').feature('param').setIndex('plistarr', '', 0);
model.study('std1').feature('param').setIndex('punit', 'F', 0);
model.study('std1').feature('param').setIndex('pname', 'c_value', 0);
model.study('std1').feature('param').setIndex('plistarr', '', 0);
model.study('std1').feature('param').setIndex('punit', 'F', 0);
model.study('std1').feature('param').setIndex('pname', 'c_value', 0);
model.study('std1').feature('param').setIndex('punit', 'pF', 0);
model.study('std1').feature('param').setIndex('plistarr', 'range(20,0.5,30)', 0);

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
model.sol('sol1').feature('s1').feature('p1').set('pname', {'c_value'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'range(20,0.5,30)'});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'pF'});
model.sol('sol1').feature('s1').feature('p1').set('sweeptype', 'sparse');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'no');
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'Default');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
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
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').label('Electric Field (emw)');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('showlegendsmaxmin', true);
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('mslc1', 'Multislice');
model.result('pg1').feature('mslc1').label('Multislice');
model.result('pg1').feature('mslc1').set('colortable', 'RainbowLight');
model.result('pg1').feature('mslc1').set('smooth', 'internal');
model.result('pg1').feature('mslc1').set('data', 'parent');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result.dataset('dset1').selection.geom('geom1', 3);
model.result.dataset('dset1').selection.geom('geom1', 3);
model.result.dataset('dset1').selection.set([3 4 5 6]);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', 18, 0);
model.result('pg2').create('slc1', 'Slice');
model.result('pg2').feature('slc1').set('quickplane', 'xy');
model.result('pg2').feature('slc1').set('quickznumber', 1);
model.result('pg2').feature('slc1').set('expr', 'emw.normB');
model.result('pg2').feature('slc1').set('descr', 'Magnetic flux density norm');
model.result('pg2').run;
model.result('pg2').create('arwv1', 'ArrowVolume');
model.result('pg2').feature('arwv1').set('expr', {'emw.Bx' 'emw.By' 'emw.Bz'});
model.result('pg2').feature('arwv1').set('descr', 'Magnetic flux density');
model.result('pg2').run;
model.result('pg2').create('arwv2', 'ArrowVolume');
model.result('pg2').feature('arwv2').setIndex('expr', 'imag(emw.Bx)', 0);
model.result('pg2').feature('arwv2').setIndex('expr', 'imag(emw.By)', 1);
model.result('pg2').feature('arwv2').setIndex('expr', 'imag(emw.Bz)', 2);
model.result('pg2').feature('arwv2').set('color', 'blue');
model.result('pg2').run;
model.result.create('pg3', 'PlotGroup1D');
model.result('pg3').run;
model.result('pg3').create('glob1', 'Global');
model.result('pg3').feature('glob1').set('expr', {'intBaxialratiodB'});
model.result('pg3').feature('glob1').set('descr', {'Integration of magnetic flux circularity around the phantom'});
model.result('pg3').feature('glob1').set('unit', {'m'});
model.result('pg3').run;
model.result('pg3').run;
model.result.create('pg4', 'PlotGroup1D');
model.result('pg4').run;
model.result('pg4').create('glob1', 'Global');
model.result('pg4').feature('glob1').set('expr', {'stdev'});
model.result('pg4').feature('glob1').set('descr', {'Standard deviation of E norm'});
model.result('pg4').feature('glob1').set('unit', {'V/m'});
model.result('pg4').run;
model.result('pg4').run;

model.param.set('c_value', '28[pF]');

model.component('comp1').material.create('mat2', 'Common');
model.component('comp1').material('mat2').selection.set([5 6]);
model.component('comp1').material('mat2').propertyGroup('def').set('relpermittivity', {'40'});
model.component('comp1').material('mat2').propertyGroup('def').set('relpermeability', {'1'});
model.component('comp1').material('mat2').propertyGroup('def').set('electricconductivity', {'0.9'});

model.study.create('std2');
model.study('std2').create('freq', 'Frequency');
model.study('std2').feature('freq').set('plotgroup', 'Default');
model.study('std2').feature('freq').set('solnum', 'auto');
model.study('std2').feature('freq').set('notsolnum', 'auto');
model.study('std2').feature('freq').activate('emw', true);
model.study('std2').feature('freq').set('plist', '63.87[MHz]');

model.sol.create('sol2');
model.sol('sol2').study('std2');

model.study('std2').feature('freq').set('notlistsolnum', 1);
model.study('std2').feature('freq').set('notsolnum', 'auto');
model.study('std2').feature('freq').set('listsolnum', 1);
model.study('std2').feature('freq').set('solnum', 'auto');

model.sol('sol2').create('st1', 'StudyStep');
model.sol('sol2').feature('st1').set('study', 'std2');
model.sol('sol2').feature('st1').set('studystep', 'freq');
model.sol('sol2').create('v1', 'Variables');
model.sol('sol2').feature('v1').set('control', 'freq');
model.sol('sol2').create('s1', 'Stationary');
model.sol('sol2').feature('s1').set('stol', 0.01);
model.sol('sol2').feature('s1').create('p1', 'Parametric');
model.sol('sol2').feature('s1').feature.remove('pDef');
model.sol('sol2').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol2').feature('s1').feature('p1').set('plistarr', {'63.87[MHz]'});
model.sol('sol2').feature('s1').feature('p1').set('punit', {'GHz'});
model.sol('sol2').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol2').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol2').feature('s1').feature('p1').set('pdistrib', 'off');
model.sol('sol2').feature('s1').feature('p1').set('plot', 'on');
model.sol('sol2').feature('s1').feature('p1').set('plotgroup', 'Default');
model.sol('sol2').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol2').feature('s1').feature('p1').set('probes', {});
model.sol('sol2').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol2').feature('s1').set('control', 'freq');
model.sol('sol2').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol2').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol2').feature('s1').create('i1', 'Iterative');
model.sol('sol2').feature('s1').feature('i1').set('linsolver', 'gmres');
model.sol('sol2').feature('s1').feature('i1').set('prefuntype', 'right');
model.sol('sol2').feature('s1').feature('i1').set('itrestart', '300');
model.sol('sol2').feature('s1').feature('i1').label('Suggested Iterative Solver (emw)');
model.sol('sol2').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').set('iter', '1');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').create('sv1', 'SORVector');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').create('sv1', 'SORVector');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol2').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol2').feature('s1').feature.remove('fcDef');
model.sol('sol2').attach('std2');

model.result.create('pg5', 'PlotGroup3D');
model.result('pg5').label('Electric Field (emw) 1');
model.result('pg5').set('showlooplevel', {'off' 'off' 'off'});
model.result('pg5').set('frametype', 'spatial');
model.result('pg5').set('showlegendsmaxmin', true);
model.result('pg5').set('data', 'dset2');
model.result('pg5').feature.create('mslc1', 'Multislice');
model.result('pg5').feature('mslc1').label('Multislice');
model.result('pg5').feature('mslc1').set('colortable', 'RainbowLight');
model.result('pg5').feature('mslc1').set('smooth', 'internal');
model.result('pg5').feature('mslc1').set('data', 'parent');

model.sol('sol2').runAll;

model.result('pg5').run;
model.result('pg5').set('data', 'dset2');
model.result.dataset('dset2').selection.geom('geom1', 3);
model.result.dataset('dset2').selection.geom('geom1', 3);
model.result.dataset('dset2').selection.set([3 4 5 6]);
model.result.create('pg6', 'PlotGroup3D');
model.result('pg6').run;
model.result('pg6').create('slc1', 'Slice');
model.result('pg6').run;
model.result('pg6').set('data', 'dset2');
model.result('pg6').run;
model.result('pg6').feature('slc1').set('expr', 'emw.normB');
model.result('pg6').feature('slc1').set('descr', 'Magnetic flux density norm');
model.result('pg6').feature('slc1').set('quickplane', 'xy');
model.result('pg6').feature('slc1').set('quickznumber', 1);
model.result('pg6').run;
model.result('pg6').create('arwv1', 'ArrowVolume');
model.result('pg6').feature('arwv1').set('expr', {'emw.Bx' 'emw.By' 'emw.Bz'});
model.result('pg6').feature('arwv1').set('descr', 'Magnetic flux density');
model.result('pg6').run;
model.result('pg6').create('arwv2', 'ArrowVolume');
model.result('pg6').feature('arwv2').setIndex('expr', 'imag(emw.Bx)', 0);
model.result('pg6').feature('arwv2').setIndex('expr', 'imag(emw.By)', 1);
model.result('pg6').feature('arwv2').setIndex('expr', 'imag(emw.Bz)', 2);
model.result('pg6').feature('arwv2').set('color', 'blue');
model.result('pg6').run;
model.result('pg6').run;
model.result.numerical.create('gev1', 'EvalGlobal');
model.result.numerical('gev1').set('data', 'dset2');
model.result.numerical('gev1').set('expr', {'intBaxialratiodB'});
model.result.numerical('gev1').set('descr', {'Integration of magnetic flux circularity around the phantom'});
model.result.numerical('gev1').set('unit', {'m'});
model.result.table.create('tbl1', 'Table');
model.result.table('tbl1').comments('Global Evaluation 1');
model.result.numerical('gev1').set('table', 'tbl1');
model.result.numerical('gev1').setResult;
model.result.numerical.create('gev2', 'EvalGlobal');
model.result.numerical('gev2').set('data', 'dset2');
model.result.numerical('gev2').set('expr', {'stdev'});
model.result.numerical('gev2').set('descr', {'Standard deviation of E norm'});
model.result.numerical('gev2').set('unit', {'V/m'});
model.result.table.create('tbl2', 'Table');
model.result.table('tbl2').comments('Global Evaluation 2');
model.result.numerical('gev2').set('table', 'tbl2');
model.result.numerical('gev2').setResult;

model.comments(['MRI Birdcage Coil\n\nThis example describes the design and optimization of a birdcage coil to provide a homogeneous magnetic field distribution for Magnetic Resonance Imaging (MRI) systems and thereby improve the resolution of scanned images. The homogeneous magnetic field is obtained by studying quadrature excitation and performing a parametric sweep to determine the optimal value of lumped elements in the coil. Sweeping over the capacitance of the lumped elements gives the optimal value for an air phantom at the desired Larmor frequency. The model also studies the performance of the coil when loaded with a human head phantom.']);

model.label('mri_coil.mph');

out = model;
