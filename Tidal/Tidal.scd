Quarks.install("SuperDirt");

SuperDirt.start;


(
var server = server ? Server.default;
server.options.memSize = 8192 * 16;
server.waitForBoot {
	~dirt=SuperDirt(2);
	~dirt.loadSoundFiles("C:/Users/Family/Desktop/Arin/LiveCode/Tidal/Drums/*",appendToExisting:true);
	~dirt.start(); // 8 orbits
}
)

s.scope;

Quarks.gui

//virtual analog synth, for emulated knob twiddling.  /volfunc is to keep it somewhat quiet, avoids clipping with superDirt verbs.

ProxyMonitorGui()

(
SynthDef.new(\dirtlog, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5|
	var sig, vEnv,fEnv, volfunc;
	vEnv = XLine.kr(1,0.0001,decay,doneAction:2);
	fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
	sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol) + ((SinOsc.ar(freq) + SinOsc.ar(freq + detune)*detvol)*sinvol)) * vEnv;
	volfunc = (puvol+sawvol+sinvol+detvol);
	sig = MoogFF.ar(sig,fEnv,mres,0)/volfunc;
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels));
}).add;

SynthDef.new(\dirtlogasr, { |out, freq, gate=0.5, attack=0.1,sustain=0,release=2,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5|
	var sig, vEnv,fEnv, volfunc;
	vEnv = EnvGen.ar(Env.asr(attack,2,release),1,4,0,1,0);
	fEnv =  EnvGen.ar(Env.asr(attack,2,release),1,mcut,0,1,2);
	sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol) + ((SinOsc.ar(freq) + SinOsc.ar(freq + detune)*detvol)*sinvol)) * vEnv;
	volfunc = (puvol+sawvol+sinvol+detvol);
	sig = MoogFF.ar(sig,fEnv,mres,0)*(0.2);
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels));
}).add;
)

)

x = Env.adsr(0.01,0.4,0.5,0.9).plot;

y = Synth.new(\sawTest, \gate, 1)