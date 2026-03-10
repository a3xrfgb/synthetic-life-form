# Step-by-Step Guide — Virtual Life Form on Your Machine

Follow one or more paths below. Each section is self-contained.

---

## Prerequisites (General)

- **Windows 10/11**, PowerShell.
- **Git**: [git-scm.com](https://git-scm.com/).
- **Disk**: ~60 GB free for OpenWorm; ~20–30 GB for fly brain + FlyGym.
- **RAM**: 16 GB minimum; 32–128 GB recommended for full fly brain.
- **GPU**: RTX 3090 (24 GB VRAM) — used by MuJoCo/FlyGym; brain model is CPU.

Optional:

- **Docker Desktop** for OpenWorm: [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/).
- **Miniconda** or **Anaconda** for Python environments: [docs.conda.io](https://docs.conda.io/en/latest/miniconda.html).

---

## Path A — OpenWorm (C. elegans “digital life”)

**What you get:** Full worm simulation — connectome (~302 neurons) + physics body (Sibernetic) + visualization. The closest to “create your own digital life form” out of the box.

### Step 1: Install Docker Desktop

1. Install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/).
2. Enable WSL 2 backend if prompted.
3. Start Docker and ensure it’s running (whale icon in tray).

### Step 2: Clone and run OpenWorm

From `c:\Users\Ababiya\.cursor\eon`:

```powershell
.\scripts\setup_openworm.ps1
```

This clones the OpenWorm repo into `openworm\` and builds/runs the stack (or use the run script after clone). Alternatively, do it manually:

```powershell
git clone https://github.com/openworm/OpenWorm.git openworm
cd openworm
# Windows:
.\run.cmd
# Or build first:
.\build.cmd
.\run.cmd
```

### Step 3: What runs

- **Sibernetic**: 3D worm body (fluid/muscle physics).
- **c302**: Nervous system model.
- **Geppetto**: Browser-based visualization (if you use the browser stack).

Default run often produces ~5–10 minutes of output. For longer runs, see [OpenWorm Docker docs](https://docs.openworm.org/Projects/docker/).

### Step 4: Explore

- **WormSim**: [wormsim.org](http://wormsim.org/) — browser-based interaction.
- **OpenWorm Browser**: [browser.openworm.org](http://browser.openworm.org/) — 3D worm anatomy.
- **Source**: [github.com/openworm](https://github.com/openworm) — Sibernetic, Geppetto, etc.

---

## Path B — Drosophila whole-brain model (Eon/Janelia)

**What you get:** The same class of model as in the Nature 2024 paper — full FlyWire connectome (125k neurons, 50M synapses), leaky integrate-and-fire, implemented in **Brian2**. No body; brain only (sensorimotor predictions, optogenetic-style experiments in silico).

### Step 1: Install Miniconda

If you don’t have conda:

1. Download [Miniconda for Windows](https://docs.conda.io/en/latest/miniconda.html).
2. Install (e.g. “Add to PATH”).
3. Open a new PowerShell and run `conda --version`.

### Step 2: Clone Eon’s brain model and create environment

From `c:\Users\Ababiya\.cursor\eon`:

```powershell
.\scripts\setup_fly_brain.ps1
```

This will:

- Clone `eonsystemspbc/drosophila_brain_model_lif` into `drosophila_brain_model_lif\`.
- Create a conda env from the repo’s `environment.yml` (or equivalent).
- Install Brian2 and deps (NumPy, Pandas, etc.).

Manual equivalent:

```powershell
git clone https://github.com/eonsystemspbc/drosophila_brain_model_lif.git
cd drosophila_brain_model_lif
conda env create -f environment.yml
conda activate drosophila_brain_model_lif   # or the env name in the file)
```

### Step 3: Get connectome data

The model uses **FlyWire** connectome (materialization v630 or similar). Data is typically pulled via:

- **CAVE** (Cloud Volume) API — see [FlyConnectome](https://github.com/seung-lab/FlyConnectome) and [codex.flywire.ai](https://codex.flywire.ai/api/download).
- Or preprocessed inputs if the repo provides them (check repo README and notebooks).

Follow the repo’s README and any “Data” or “Setup” sections for exact steps (tokens, env vars, or download scripts).

### Step 4: Run a small example

- Open a Jupyter notebook from the repo (e.g. one that activates sugar GRNs or runs a small subgraph).
- Run cells; first run may download/prepare data.  
- Full 125k-neuron runs are CPU-bound; 16 cores will significantly speed them up. Brian2 can use C++ codegen for speed (see Brian2 docs).

### Step 5: Optional — Brian2 with C++

For better performance:

```bash
# In the same conda env
conda install -c conda-forge cython
# Then in Python/Brian2, set codegen target to 'cython' or 'cpp' as per Brian2 docs
```

---

## Path C — NeuroMechFly v2 / FlyGym (fly body in MuJoCo)

**What you get:** Realistic fruit fly body in MuJoCo: walking, turning, terrain, leg adhesion, vision, olfaction. Controllers can be rule-based, CPG, or RL. This is the *body* side of what Eon showed; you can later try to drive it from a brain model (advanced).

### Step 1: Conda

Use the same Miniconda (or Anaconda) as in Path B.

### Step 2: Clone FlyGym and create environment

From `c:\Users\Ababiya\.cursor\eon`:

```powershell
.\scripts\setup_flygym.ps1
```

This clones **FlyGym** (NeuroMechFly v2) and sets up a conda env with MuJoCo and the package. Manual:

```powershell
git clone https://github.com/NeLy-EPFL/flygym.git
cd flygym
# Prefer repo's install instructions; typically:
conda create -n flygym python=3.10 -y
conda activate flygym
pip install mujoco
pip install -e .   # or pip install flygym
```

### Step 3: Run a simple example

Docs: [neuromechfly.org](https://neuromechfly.org/). Example pattern:

```python
import gymnasium as gym
import flygym

env = gym.make("FlyGym-v0")  # or the env name from docs
obs, info = env.reset()
for _ in range(500):
    action = env.action_space.sample()  # or your controller
    obs, reward, terminated, truncated, info = env.step(action)
    if terminated or truncated:
        obs, info = env.reset()
env.close()
```

MuJoCo can use the GPU for rendering/physics; your RTX 3090 will help for fast stepping and visualization.

### Step 4: Explore controllers and tasks

- Use built-in controllers (CPG, rule-based, hybrid) for walking on flat/rugged terrain.
- Try RL training (e.g. obstacle avoidance + odor navigation) as in the NeuroMechFly v2 paper.
- Connectome-constrained visual tracking examples are in the repo/paper.

---

## Optional: Brain + body (Eon-like loop)

Conceptually:

1. **Brain**: Run Eon’s Brian2 model; define “sensory” inputs (e.g. from FlyGym observations) and read “motor” outputs (e.g. descending commands).
2. **Body**: Run FlyGym; at each step, feed observations into the brain model and send the brain’s motor output to the simulator.

This requires:

- Mapping FlyGym observation space → neuron IDs (e.g. sensory GRNs, JONs).
- Mapping brain motor outputs (e.g. MN9, aDN1) → FlyGym action space (joint targets, adhesion).
- Synchronizing time steps and possibly simplifying one side (e.g. reduced brain or precomputed motor patterns).

No single script does this end-to-end in public repos; treat it as a follow-on project once both Path B and Path C work on your machine.

---

## Troubleshooting

- **Docker (OpenWorm):** “Docker daemon not running” → start Docker Desktop. WSL 2 and enough memory (e.g. 4 GB for Docker) help.
- **Conda (fly brain):** If `environment.yml` fails, create env with Python 3.9/3.10 and install dependencies from the repo’s requirements or README.
- **FlyWire data:** You may need a FlyWire token or API access; check the brain model repo and [FlyWire docs](https://flywire.ai).
- **MuJoCo (FlyGym):** On Windows, use MuJoCo 2.3+ and a supported Python (e.g. 3.10). If you see GPU errors, try CPU rendering first.

---

## Summary

| Path   | Main artifact           | Run command / entry point        |
|--------|--------------------------|-----------------------------------|
| A      | OpenWorm (worm)          | `.\run.cmd` in `openworm\`        |
| B      | Drosophila brain (Brian2)| Conda env + Jupyter in `drosophila_brain_model_lif\` |
| C      | Fly body (FlyGym)        | `conda activate flygym` + Python / gym make |

For “create your own digital life form” quickly → **Path A**.  
For the “fruit fly brain in a machine” → **Path B**.  
For the “fruit fly body in a simulator” → **Path C**.  
For “brain + body” later → combine B + C with custom integration.
