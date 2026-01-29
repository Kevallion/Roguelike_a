# Project Organization for Roguelike_a (Godot)

This document outlines the file and folder structure of the `Roguelike_a` Godot project, as analyzed for the Gemini CLI.

## Overview
The project appears to follow a component-based architecture common in Godot, with clear separation of concerns for assets, game logic, UI, units, and utilities.

## Directory Structure Summary:

-   **Root (`C:\Users\wislo\Documents\MEGA\GameDev\Godot\Roguelike_a\`):** Contains core project files like `project.godot`, main scenes (`main_game.tscn`), and global scripts (`hud.gd`).

-   **`.godot/`:** Godot's internal cache and generated files.

-   **`.vscode/`:** VS Code specific configurations (e.g., `launch.json`).

-   **`asset/`:** Stores all game assets, further categorized into:
    -   `Enemies/`: Enemy sprites and related imports (e.g., `rat.png`, `tile_0108.png`).
    -   `Environment/`: Environment tilesets, textures, and world configurations (e.g., `environment_tileset.tres`, `tilemap_packed.png`, `world_environment.tscn`).
    -   `Heroes/`: Player character sprites and related imports (e.g., `knight.png`, `tile_0087.png`).
    -   `ui/`: User interface graphics, including skill icons (e.g., `overlay_cells.png`, `Button3.png`, skill `.tres` files).

-   **`autoload/`:** Contains global singletons/autoload scripts for managing various game aspects. These scripts are loaded at startup and are globally accessible:
    -   `audio_manager.gd`: Manages in-game audio.
    -   `gamestate.gd`: Handles the overall state of the game.
    -   `globals.gd`: Stores global variables and constants.
    -   `runData.gd`: Manages data specific to a game run.
    -   `scenechanger.gd`: Manages transitions between scenes.
    -   `signalBus.gd`: Provides a central hub for custom signals/events.

-   **`CommandManager/`:** Scripts defining different types of game actions as commands, promoting a clear command pattern:
    -   `attackCommand.gd`
    -   `buffCommand.gd`
    -   `command.gd` (base command)
    -   `healCommand.gd`
    -   `moveCommand.gd`

-   **`cursor/`:** Contains resources for custom in-game cursors:
    -   `cursor.gd`
    -   `cursor.tscn`

-   **`environment/`:** Defines level structures and environment-related components:
    -   `level.gd`: Base script for game levels.
    -   `levels/`: Specific level scenes (e.g., `level_01.tscn`) and components (e.g., `camera_component.gd`).

-   **`gamemanager/`:** Core game logic managers:
    -   `game_board.gd`: Manages the game board, likely grid-based.
    -   `turn_manager.gd`: Orchestrates turns for players and enemies.

-   **`UI/`:** User interface scenes and scripts:
    -   `amount_visual.gd`, `amount_visual.tscn`: Visual feedback for numerical values.
    -   `game_over.gd`, `game_over.tscn`: The game over screen.
    -   `skil_bar.gd`, `skill_button.tscn`, `skilll_button.gd`: Components for a skill bar.
    -   `Font/`: Directory for custom font resources.

-   **`unit/`:** Defines game units (players and enemies) and their associated components and resources:
    -   `stats_components.gd`: Script for unit statistics.
    -   `unit_overlay.gd`, `unit_overlay.tscn`: Overlays displayed on units (e.g., health bars).
    -   `unit_path.gd`, `unit_path.tres`, `unit_path.tscn`: Resources and scripts for unit pathfinding visualization.
    -   `unit.gd`, `unit.tscn`: Base script and scene for a generic unit.
    -   `Enemy/`: Specific implementations for enemy units:
        -   `enemy.gd`, `enemy.tscn`: Base enemy script and scene.
        -   `rat_stats.tres`: Resource for rat enemy statistics.
    -   `Player/`: Specific implementations for the player unit:
        -   `knight_stats.tres`: Resource for knight player statistics.
        -   `player.gd`, `player.tscn`: Player script and scene.
        -   `Knight/`: Player-specific resources like attack and skill definitions (`basic_attack.tres`, `fracas.tres`, `health.tres`).
    -   `ressourses/`: Shared unit resources:
        -   `unit_stats.gd`: General unit statistics definition.
        -   `skills/skills_data.gd`: Data for unit skills.

-   **`utils/`:** General utility scripts and resources:
    -   `Grid.gd`, `Grid.tres`: Implementation and resource for a grid system.
    -   `pathfinder.gd`: Script containing pathfinding algorithms.