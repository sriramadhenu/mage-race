# mage-race
A 2D puzzle-platformer game combining combat and puzzle mechanics

## Team
- **Sri** - Game Logic & Build/Release Management
- **Dunh** - UI/Input & Gameplay Testing
- **Jacob** - AI/Behavior & Game Feel
- **Frank** - Level Design & Tutorial Design
- **Sarayu** - Movement/Physics & Audio
- **Thomas** - Technical Art & Narrative Design

## Setup

1. **Accept the GitHub invite** (check your email)

2. **Clone the repo:**
```bash
   git clone https://github.com/sriramadhenu/mage-race.git
   cd mage-race
```

3. **Open in Godot:**
   - Launch Godot
   - Click "Import"
   - Select the `project.godot` file

4. **Create your feature branch:**
```bash
   git checkout -b feature/your-name
```

### Starting work:
```bash
git pull origin develop    # Get latest changes
git checkout feature/your-name
```

### Saving your work:
```bash
git add .
git commit -m "description of what you did"
git push origin feature/your-name
```

## Level Development Workflow

We are using **sequential level development**:

1. First work on the base level layout (tilemaps, platforms)
2. Next, visual polish (lighting, particles, backgrounds)  
3. Add puzzles (buttons, doors, moving objects)
4. Add enemies (spawns, AI configuration)
5. Add audio, UI, final touches (music, sound effects)

### Rules:
- Wait for the previous person to finish before starting your work
- Pull from `develop` before starting: `git pull origin develop`

### Commands for Each Step:

```bash
# 1. Get the latest version:
git checkout develop
git pull origin develop

# 2. Create/switch to your feature branch:
git checkout -b feature/your-name
# Or if your branch already exists:
git checkout feature/your-name

# 3. Make sure your branch has the latest develop changes:
git merge develop

# 4. Open Godot and do your work on the level

# 5. Save your work:
git add .
git commit -m "describe what you did"
git push origin feature/your-name
