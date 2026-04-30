# Gradient of Gradients

`Gradient of Gradients` is a lightweight Godot editor addon for building 2D colour ramps from multiple standard `Gradient` resources.

It is useful when a single gradient is not enough and you need colour to shift across two directions, such as:

- skies and horizon blends
- biome or heatmap palettes
- stylised lighting or fog lookups
- UI and VFX colour tables

## What It Does

- adds a custom `GradientOfGradients` resource
- lets you place multiple gradients along a normalized `t` axis
- blends between those gradients at runtime
- includes a custom inspector for editing and previewing the result in Godot

## Typical Use

Create a `GradientOfGradients` resource, add a few `GradientPoint` entries, assign a `Gradient` to each one, and position them with `t` values from `0.0` to `1.0`.

From code, sample colours directly or generate an image/texture from the resource.

## Project Fit

This addon is small, self-contained, and intended for teams that want a cleaner workflow for art-driven gradient blending without building a custom shader or editor tool from scratch.
