// Each  draw  item  is  a  very  compact  structure,  containing  state  IDs.
// XOR’ingtwo  draw  items  creates  a  bitmask  that  highlights  any  changes.
// Masking  out  sections  of  that  bitmask  and  comparing  them  to  zero  lets  you  quickly  check  if  a  state  has  changed  since  the  previous  draw  item.

# Low Level

## Primitives

### BufferUsage (Enumeration)
- (0x0) READBACK     - Buffer is used to store data from device operations such as screenshots, occlusion depth buffer _readback_, etc.
- (0x1) UPLOAD       - Buffer is used to upload dynamic geometry(, textures, uniforms, etc) as a staging buffer for _static_ **DEVICE_LOCAL** buffers.
- (0x2) DEVICE_LOCAL - Buffer is used to store data that needs to be efficiently fetched by the device: rendertargets, textures, (static) buffers.

### BufferType (Enumeration, Flags)
- (0x1) VERTEX       - This type of buffer is used for storing vertex data for geometry.
- (0x2) INDEX        - This type of buffer is used for storing indices for which to draw the data.
- (0x2) UNIFORM      - This type of buffer is used for setting constants / uniforms to the shader.

## Render Commands
- begin
- clear
- viewport
- end
- wait

## Uniforms
- 

# Mid Level Commands

## Matrix OPs


## Buffer OPs
// 16-byte alignment
- updateBuffer

- bindVertexBuffer
- bindIndexBuffer
- bindMaterial

# High Level Abstraction

// IDEA : Use Lua as a DSL for defining 'Techniques' rather than hardcoding them
// Use sorting Keys
//  But if Alpha blended: ~*(u32*)distance as the sorting key
//  Opaque can use a bybrid to do front to back. (mix original sort key and distance)

- Shaders
  - Shaders can indicaste what slots it uses using a bit mask
    - EX: ((1 << 0) | (1 << 2)) for using samplers 0 and 2
- Techniques
  - A Technique contains several Shaders for each of it's multiple passes.

- The API uses the concept of a __DrawItem__
  - A **DrawItem** contains all of the state except for Depth / Stencil Target and Render Targets.

```cpp

MaterialGenerator& mg = engine->material_generator();

mg.begin(/* maybe do inheiritance here */);
mg.setTexture(0, mTextureDiffuse);
mg.setTexture(1, mTextureSpecular);
mg.setTexture(2, mTextureNormal);
mg.setBlend(BLEND_NORMAL);
mg.setShader(lightingShader);

Material* material = mg.end();

  // 'material' overrides whatever 'defaults' defines as far as state goes.
Material* material_inheiritance[] = {defaults, material};

DrawCommand cmd = {TRIANGLES, 3};

DrawItem* draw_item = compile(material_inheiritance, cmd);
```

---
# Graphics Notes

## Vulkan

- Vulkan's Memory Model
  - Has two aspects "visibility" and "availibility"
    - HOST_COHERENT / vkFlushMappedMemoryRanges is all about visibility
    - Availibility is from waiting on resources using primitives such as: Events, Fences, and Semaphores.
      - The device would use "vkPipelineBarrier"s rather than fences (which is generally for the host)

- USE HOST_COHERENT or "vkFlushMappedMemoryRanges"
- vkQueueSubmit automatically creates a memory barrier between (properly flushed) host writes issued before vkQueueSubmit and any usage of those writes from the command buffers in the submit command (and of course, commands in later submit operations).
- All you have to do for "vkMapMemory" since it doens't tell you if the device is using the data is to use a fence (the fence from the submission).
  - Since when you submit is the only time the device is going to use that mapped memory.

## Buffer Usage Patterns

| Life Time  | Example              | Update Frequency (0 - 4) |
|:---------- |:--------------------:| ------------------------:|
| "Forever"  | Level Geometry       | 0                        |
| Long Lived | Character Models     | 1                        |
| Transient  | UI, Text             | 2                        |
| Temporary  | Particles (Streamed) | 3                        |
| Constants  | Shader Uniforms      | 4                        |

- "Forever"
  - Should be loaded from behind a load screen since this is so rare.
  - Make these immutable since we wont be updating these.
  - Use a staging buffer so these can this can use GPU device local storage.
- Long Lived
  - The average case so use the defaults for this.
  - Should probably use a staging buffer still.
- Transient
  - 
- Temporary
  - Uses a dynamic buffer that is host visible.
  - Pretty much lives in RAM. (map and unMap)
  - OpenGL - DYNAMIC flag.
- Constants
  - 