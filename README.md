# Room Zero 🔐

A 3D isometric top-down escape room puzzle game built with **Godot 4**.

## The Game

You wake up in a mysterious room. The door is locked. Find clues, solve puzzles, and escape **Room Zero**.

### Puzzle Flow

1. **Examine the book** on the table → reveals a torn note with partial code: `7 _ _ 3`
2. **Open the drawer** → find a scrap of paper with: `_ 2 8 _`
3. **Combine the clues** → the safe code is `7283`
4. **Enter the code** into the safe's keypad → safe opens, revealing a rusty key
5. **Use the key** on the locked door → escape!

## Controls

- **Left Click** on objects to interact
- **Left Click** on the floor to move
- Click an **inventory item** to select it, then click an object to use it

## Project Structure

```
scenes/           → Godot scene files (.tscn)
scripts/          → GDScript files
  objects/        → Scripts for interactable objects (book, drawer, safe, door)
resources/items/  → Item data resources (.tres)
ui/               → UI-related assets
```

## Core Systems

| System | Description |
|--------|-------------|
| **Inventory** | Autoload singleton — collect, select, and use items |
| **GameState** | Autoload singleton — tracks puzzle states and win condition |
| **Interactable** | Base class for clickable objects with highlight on hover |
| **Navigation** | NavigationRegion3D + NavigationAgent3D for pathfinding |

## Getting Started

1. Clone this repo
2. Open in **Godot 4.4+**
3. Hit Play (F5)

## Extending

- Add new rooms by creating new scenes and connecting doors
- Create new items by adding `.tres` resources in `resources/items/`
- Add interactable objects by extending the `Interactable` class

## License

MIT
