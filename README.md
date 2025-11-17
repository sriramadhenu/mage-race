# mage-race

A 2D puzzle-platformer game combining combat and puzzle mechanics - ECS 179 Final Project

## Team
- **Sri** - Game Logic & Build/Release Management
- **Dunh** - UI/Input & Gameplay Testing
- **Jacob** - AI/Behavior & Game Feel
- **Frank** - Level Design & Tutorial Design
- **Sarayu** - Movement/Physics & Audio
- **Thomas** - Technical Art & Narrative Design

## Setup

1. **Accept the GitHub invite**

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
   Example: `feature/frank` or `feature/sarayu`

## Daily Workflow

### Starting work:
```bash
git checkout develop
git pull origin develop              # Get latest changes
git checkout feature/your-name       # Switch to your branch
git merge develop                    # Bring latest changes into your branch
```

### Saving your work:
```bash
git add .
git commit -m "description of what you did"
git push origin feature/your-name
```

### When you're done with a feature:

1. Push your final changes:
```bash
   git push origin feature/your-name
```

2. Go to GitHub: https://github.com/sriramadhenu/mage-race

3. Click the **"Compare & pull request"** button (appears after you push)

4. Fill in the PR details:
   - **Base**: `develop`
   - **Compare**: `feature/your-name`
   - **Title**: Clear description (e.g., "Add level 1 base layout")
   - **Description**: Explain what you did

5. Click **"Create pull request"**

## Level Development Workflow

We use **sequential level development** in this order:

1. **Base layout** - tilemaps, platforms, level structure
2. **Visual polish** - lighting, particles, backgrounds  
3. **Puzzles** - buttons, doors, moving objects
4. **Enemies** - spawns, AI configuration
5. **Polish** - audio, UI, final touches

### Rules:
- Always start from the latest `develop` branch
- Work on your own feature branch
- Create a Pull Request when done
- Review and merge work into develop branch

## Branch Structure

- **`main`** = Stable builds only
- **`develop`** = Integration branch where all features combine
- **`feature/your-name`** = Your personal work branch

**Important:** Never push directly to `main` or `develop`!

## Help

**If the game won't run**
- Pull latest: `git pull origin develop`
- Reimport assets in Godot

**Testing someone else's work**
```bash
git fetch origin
git checkout feature/their-name
# Open in Godot and test
```
