# Create Your Own Virtual Life Form — Local Setup Guide

A step-by-step guide to run **digital organism** simulations on your machine, inspired by whole-brain emulation (fruit fly, C. elegans) and the Eon / OpenWorm ecosystems. Optimized for **Windows**, with an **RTX 3090** and **Ryzen 16-core** in mind.

---

## What You’re Recreating vs What’s Public

| What you heard about | What it is | Can you run it locally? |
|----------------------|------------|--------------------------|
| **Eon’s “first mind upload” video** | Full fly connectome (125k neurons, 50M synapses) + embodied MuJoCo body; closed sensorimotor loop. | **Brain model: yes** (open-source). **Full embodied demo**: Eon’s integration is proprietary; you can approximate it with public pieces. |
| **OpenWorm** | First “virtual organism in a computer” — C. elegans (~302 neurons), full body + physics. | **Yes.** Docker stack runs the full simulation locally. |
| **Fruit fly whole-brain model (Nature 2024)** | Leaky integrate-and-fire model of entire Drosophila brain in **Brian2**; uses FlyWire connectome. | **Yes.** Code: `eonsystemspbc/drosophila_brain_model_lif`. Runs on CPU (multi-core helps). |
| **NeuroMechFly v2** | Realistic fly *body* in MuJoCo: vision, olfaction, terrain, adhesion. Used by Eon for the body. | **Yes.** Package: **FlyGym** (`NeLy-EPFL/flygym`). Good use of GPU for physics. |

**Hardware note:** RTX 3090 has **24 GB VRAM** (enough for MuJoCo/FlyGym). If you have **128 GB system RAM**, that’s ideal for large connectome runs and Docker.

---

## Three Paths You Can Take

1. **Path A — OpenWorm (easiest “digital life”)**  
   Run the full C. elegans worm: nervous system + physics body in Docker. No brain data download; ~60 GB disk.

2. **Path B — Fruit fly *brain* only**  
   Run the full Drosophila LIF model (125k neurons, 50M synapses) from Eon’s repo. CPU-heavy; 16 cores will help.

3. **Path C — Fruit fly *body* (NeuroMechFly v2 / FlyGym)**  
   Run the embodied fly in MuJoCo: walk, turn, terrain, vision, odor. Optional: later drive it from a brain model (advanced).

**Ultimate goal (conceptually):** Path B (brain) + Path C (body) ≈ what Eon showed — connectome-driven behavior in a simulated body. Doing that end-to-end yourself is an advanced integration project; this guide gets you to the point where both halves run on your machine.

---

## Quick Start (Choose One)

### Path A — OpenWorm (recommended first)

```powershell
cd c:\Users\Ababiya\.cursor\eon
.\scripts\setup_openworm.ps1
# Then run: .\scripts\run_openworm.ps1  (or use run.cmd from the cloned repo)
```

### Path B — Drosophila brain model

```powershell
cd c:\Users\Ababiya\.cursor\eon
.\scripts\setup_fly_brain.ps1
# Then activate conda and run notebooks from brain_model repo (see STEP-BY-STEP-GUIDE.md)
```

### Path C — Fly body (FlyGym / NeuroMechFly v2)

```powershell
cd c:\Users\Ababiya\.cursor\eon
.\scripts\setup_flygym.ps1
# Then: conda activate flygym  and run Python examples (see STEP-BY-STEP-GUIDE.md)
```

---

## Repository Layout

```
eon/
├── README.md                    # This file
├── STEP-BY-STEP-GUIDE.md        # Detailed steps for each path
├── REFERENCES.md                # All links, papers, and resources
└── scripts/
    ├── setup_openworm.ps1        # Clone OpenWorm + Docker run
    ├── run_openworm.ps1         # Run OpenWorm container
    ├── setup_fly_brain.ps1      # Eon Drosophila brain model (conda)
    └── setup_flygym.ps1         # FlyGym / NeuroMechFly v2 (conda)
```

---

## Next Steps

1. Read **STEP-BY-STEP-GUIDE.md** for each path you care about.
2. Use **REFERENCES.md** for papers, datasets (FlyWire, MICrONS), and tools (brain-map, Geppetto).
3. Run the scripts from this folder; they assume PowerShell and optional Docker/Conda.

**References (short):**  
- Eon: [eon.systems](https://eon.systems) | [The Innermost Loop – First multi-behavior brain upload](https://theinnermostloop.substack.com/p/the-first-multi-behavior-brain-upload)  
- OpenWorm: [openworm.org](https://openworm.org) | [WormSim](http://wormsim.org/) | [Geppetto](http://www.geppetto.org/)  
- Fly brain: [Nature 2024 – Drosophila computational brain model](https://www.nature.com/articles/s41586-024-07763-9) | [FlyWire](https://flywire.ai)  
- Fly body: [NeuroMechFly v2](https://neuromechfly.org) | [FlyGym](https://github.com/NeLy-EPFL/flygym)
