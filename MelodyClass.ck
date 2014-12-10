//
//  MelodyClass.ck
//  CHmUsiCK
//
//  Created by Esteban Betancur on 18/10/14.
//  Copyright (c) 2014 Esteban Betancur. All rights reserved.
//

public class Melody extends CHmUsiCK
{   
    Gain vol => Master => outlet;
    ADSR envelope;
    
    SinOsc sin; SqrOsc sqr; PulseOsc pulse; SawOsc saw;TriOsc tri;
    [sin,sqr,pulse,saw,tri] @=> Osc osc[];
    
    0 => int activeOsc;
    
    BandedWG BWG; BlowBotl BB; Wurley W; TubeBell TB; Bowed bow;
    Rhodey rhod; PercFlut PF; BlowHole BH; HevyMetl HM; ModalBar MB;
    Flute flut; Mandolin mandol; Saxofony sax; Moog mg; Sitar sit; 
    StifKarp SK; BeeThree BT; FMVoices fmv;
    [BWG,BB,W,TB,bow,rhod,PF,BH,flut,mandol,MB,mg,sax,sit,SK,BT,fmv,HM] @=> StkInstrument inst[];
    
    0 => int activeInst; 
    
    OverallTempo => float Tempo;
    OverallDivision => int Division;
    
    int Notes[0];
    
    //———————————-envelope————————————//
    10::ms => dur A;
    8::ms => dur D;
    0.5 => float S;
    5::ms => dur R;
    
    envelope.set(A, D, S, R);
    
    public float gain(float volum)
    {
        volum => vol.gain; 
        return vol.gain();
    }
    public float gain()
    {
        return vol.gain();
    }
    public float tempo(float t)
    {
        t => Tempo;
        return Tempo;
    }
    public float tempo()
    {
        return Tempo;
    }
    public int subdivision(int div)
    {
        div => Division;
        return Division;
    }
    public int subdivision()
    {
        return Division;
    }
    public int[] setNotes(int notes[])
    {
        notes @=> Notes;
        return Notes; 
    }
    public int[] setNotes()
    {
        return Notes;
    }
    private dur Dur(dur beat, int div)
    {
        (div / 4) => float factor;
        (beat / factor) => dur tempo;
        return tempo;
    }
    private dur convert(float beat)
    {
        60/beat => float tempo;
        return tempo::second;
    }
    private float convertD(dur beat)
    {
        ((60::second/beat)$float) => float tempo;
        return tempo;
    }
    public dur attack(dur attacK)
    {
        attacK => A;
        return A;
    }
    public dur attack()
    {
        return attack(A);
    }
    public dur decay(dur decaY)
    {
        decaY => D;
        return D;
    }
    public dur decay()
    {
        return decay(D);
    }
    public float sustain(float sustaiN)
    {
        sustaiN => S;
        return S;
    }
    public float sustain()
    {
        return sustain(S);
    }
    public dur release(dur releasE)
    {
        releasE => R;
        return R;
    }
    public dur release()
    {
        return release(R);
    }
    public int controlChangeOsc(int parameter)
    {
        parameter => activeOsc;
        return activeOsc;
    }
    public int controlChangeOsc()
    {
        return controlChangeOsc(activeOsc);
    }
    public int controlChange(int parameter)
    {
        parameter => activeInst;
        return activeInst;
    }
    public int controlChange()
    {
        return controlChange(activeInst);
    }
    public int[] random(int capacity)
    {
        int melody[capacity];
        
        Notes harmony;
        harmony.voicing(harmony.randomNote()) @=> int notes[];
        
        for(0 => int i; i < melody.cap(); i++)
        {
            notes[Math.random2(0,(notes.cap()-1))] @=> melody[i];
        }  
        return melody;
    }
    public int[] random(string key, int capacity)
    {
        int melody[capacity];
        
        Notes harmony;
        harmony.voicing(key) @=> int notes[];
        
        for(0 => int i; i < melody.cap(); i++)
        {
            notes[Math.random2(0,(notes.cap()-1))] @=> melody[i];
        }  
        return melody;
    }
    public void randomMelody()
    {
        controlChange(Math.random2(0,17));
        Math.random2(0,Math.random2(0,64)) => int capacity;
        synth(convert(Tempo),Division,random(capacity));
    }
    public void randomMelody(int capacity)
    {
        synth(convert(Tempo),Division,random(capacity));
    }
    public void randomMelody(float beat ,int capacity)
    {
        synth(convert(beat),Division,random(capacity));
    }
    public void randomMelody(dur beat ,int capacity)
    {
        synth(beat,Division,random(capacity));
    }
    public void randomMelody(float beat, int div ,int capacity)
    {
        synth(convert(beat),Division,random(capacity));
    }
    public void randomMelody(dur beat, int div ,int capacity)
    {
        synth(beat,div,random(capacity));
    }
    public void randomMelody(float beat, int div ,int capacity, string key)
    {
        synth(convert(beat),div,random(key,capacity));
    }
    public void randomMelody(dur beat, int div ,int capacity, string key)
    {
        synth(beat,div,random(key,capacity));
    }
    //———————————————synth——————————————//
    public void synthOsc()
    {
        synthOsc(convert(Tempo),Division,Notes);
    }
    public void synthOsc(int notes[])
    {
        synthOsc(convert(Tempo),Division,notes);
    }
    public void synthOsc(float beat,int notes[])
    {
        synthOsc(convert(beat),Division,notes);
    }
    public void synthOsc(dur beat,int notes[])
    {
        synthOsc(beat,Division,notes);
    }
    public void synthOsc(float beat,int div,int notes[])
    {
        synthOsc(convert(beat),div,notes);
    }
    public void synthOsc(dur beat,int div,int notes[])
    {
        convertD(beat) => Tempo;
        div => Division;
        setNotes(notes);
        
        osc[activeOsc] => envelope => vol;
        
        while(true)
        {
            for(0 => int i; i < notes.cap(); i++)
            {
                if(notes[i] == 0)
                {
                    envelope.keyOff();
                    Dur(beat,div) => now;
                }
                else
                {
                    Std.mtof(notes[i]) => osc[activeOsc].freq;
                    envelope.keyOn();
                    Dur(beat,div) => now;
                    envelope.keyOff();
                }
            }          
        }
    }
    public void synth()
    {
        synth(convert(Tempo),Division,Notes);
    }
    public void synth(int notes[])
    {
        synth(convert(Tempo),Division,notes);
    }
    public void synth(float beat,int notes[])
    {
        synth(convert(beat),Division,notes);
    }
    public void synth(dur beat,int notes[])
    {
        synth(beat,Division,notes);
    }
    public void synth(float beat,int div,int notes[])
    {
        synth(convert(beat),div,notes);
    }
    public void synth(dur beat,int div,int notes[])
    {
        convertD(beat) => Tempo;
        div => Division;
        setNotes(notes);
        
        inst[activeInst] => vol;
        
        while(true)
        {
            for(0 => int i; i < notes.cap(); i++)
            {
                if(notes[i] == 0)
                {
                    inst[activeInst].noteOff;
                    Dur(beat,div) => now;
                }
                else
                {
                    Std.mtof(notes[i]) => inst[activeInst].freq;
                    1 => inst[activeInst].noteOn;
                    inst[activeInst].noteOn;
                    Dur(beat,div) => now;
                    inst[activeInst].noteOff;
                }
            }          
        }
    }
}