# NORSE CODE: Engine Spec. 2018

---
## Overview
  - This document describes the API design of the Engine as a whole not on any specifics.
  - Typically you will need to add more functionality than what is described here but this is the baseline so that all engine Modules can interact with eachother in a sane way.
  - The member variables on any class is a suggestion while the __member functions are a requirement__.
  - If you are contributing to the Engine layer of this project you must follow the [Style Guide](style_guide_2018.md)
---

## Engine Module List

- [Graphics](#graphics)
  - Sprite
  - TileMap
  - Texture
  - Material
  - Camera
- [GameStates]()
- [Audio]()
- [AI]()
- [Threading]()
  - JobQueue
  - Job
- [Meta Type Informtion]()
- [User Interface]()
- [AsseIO]()
- [Animation]()
- [Data Structures]()
- [Memory Management]()
- [Physics]()
  - [Collision]()
  - RigidBody
  - Link
- [Behaviors]()
- [Core]()
  - SubSystem
  - GameStates
- [Component]()
  - Component
- [Math]()
- [Debug]()
- [Scripting]()
- [Events]()
  - [Input]()




# Graphics
- The Graphics Module will be largely based off of the concept of materials that contain whole pipeline states for easy batch management.
- The Renderer should be separated into 3 Layers of abstraction the highest layer being what the rest of the Modules will be interfacting with.
  - High Level
    - Will contain code that will be used to interface with the Graphics Module from other Engine Modules.
  - Mid Level
    - This layer will contain code that will make it easier for the graphics programmers to work on adding new functionality to the engine.
  - Low Level
    - This leel will typically just be a thin wrapper around the underlying graphics API (OpenGL, DirectX, etc) that we will be using.

## High Level Renderer

### BlendMode (enum class)
  - NONE
  - ALPHA_BLENDING
  - ADDITIVE_BLENDING
  
### DrawMode (enum class)
  - ``` POINT_LIST      (GL_POINTS) ```
  - ``` LINE_LIST       (GL_LINES) ```
  - ``` LINE_STRIP      (GL_LINE_STRIP) ```
  - ``` LINE_LOOP       (GL_LINE_LOOP) ```
  - ``` TRIANGLE_LIST   (GL_TRIANGLES) ```
  - ``` TRIANGLE_STRIP  (GL_TRIANGLE_STRIP) ```
  - ``` TRIANGLE_FAN    (GL_TRIANGLE_FAN) ```

### Material (class)
- Member Variables
  - ``` BlendMode                       m_BlendMode;      ```
  - ``` DrawMode                        m_DrawMode;       ```
  - ``` HashMap<const char*, float>     m_FloatValues;    ```
  - ``` HashMap<const char*, Texture*>  m_TextureValues;  ```
  - ``` Shader*                         m_Shader;         ```

- Member Functions
  - ``` BlendMode setBlendMode(BlendMode mode);                           ```
  - ``` DrawMode  setDrawMode(DrawMode mode);                             ```
  - ``` float     value(const char* value_name);                          ```
  - ``` void      setValue(const char* value_name, float value);          ```
  - ``` Texture*  texture(const char* texture_name);                      ```
  - ``` void      setTexture(const char* texture_name, Texture* texture); ```
  - ``` Shader*   shader(void);                                           ```
  - ``` void      setShader(Shader* shader);                              ```

### Texture
- Member Variables

- Member Functions

### Color (class)
- Member Variables
  - ``` std::uint32_t m_Value; ```

- Member Functions
  - ``` std::uint8_t r() const; ```
  - ``` std::uint8_t g() const; ```
  - ``` std::uint8_t b() const; ```
  - ``` std::uint8_t a() const; ```
  - ``` void         setR(const std::uint8_t value); ```
  - ``` void         setG(const std::uint8_t value); ```
  - ``` void         setB(const std::uint8_t value); ```
  - ``` void         setA(const std::uint8_t value); ```

### Vertex (class)
- Member Variables
  - ``` Vec4  m_Position; ```
  - ``` Color m_Color;    ```
  - ``` Vec2  m_UV;       ```

- Member Functions
  - ``` Vec4&   position(); ```
  - ``` Color&  color();    ```
  - ``` Vec2&   uv();       ```

### Transform (class)
- Member Variables
  - ``` Vec3  m_Position; ```
  - ``` Vec3  m_Origin;   ```
  - ``` Vec3  m_Scale;    ```
  - ``` Vec3  m_Size;    ```
  - ``` float m_Rotation; ```
  
- Member Functions
  - ``` inline glm::vec3&        position()        { return m_Position;  } ```
  - ``` inline glm::vec3&        scale()           { return m_Scale;     } ```
  - ``` inline glm::vec3&        size()            { return m_Size;      } ```
  - ``` inline float             rotation()  const { return m_Rotation;  } ```
  - ``` inline const glm::vec3&  position()  const { return m_Position;  } ```
  - ``` inline const glm::vec3&  scale()     const { return m_Scale;     } ```
  - ``` inline const glm::vec3&  size()      const { return m_Size;      } ```
  - ``` const glm::mat4& matrix() const;                                   ```

#### Transform (Implementation Details)
  ```cpp
    const glm::mat4& Transform::matrix() const
    {
      if (isDirty())
      {
        if (m_Parent) 
        {
          m_Matrix = m_Parent->matrix();
        }
        else 
        {
          m_Matrix = glm::mat4(1.0f);
        }

        m_Matrix = glm::translate(m_Matrix, -m_Origin);
        m_Matrix = glm::scale(m_Matrix, m_Size * m_Scale);
        m_Matrix = glm::rotate(m_Matrix, m_Rotation, glm::vec3(0.0f, 0.0f, 1.0f));
        m_Matrix = glm::translate(m_Matrix, m_Position);
        m_Matrix = glm::translate(m_Matrix, m_Origin);

        m_OldPosition = m_Position;
        m_OldOrigin = m_Origin;
        m_OldScale = m_Scale;
        m_OldSize = m_Size;
        m_OldRotation = m_Rotation;
      }

      return m_Matrix;
    }

    bool Transform::isDirty() const
    {
      return 
        m_Position != m_OldPosition ||
        m_Origin != m_OldOrigin ||
        m_Scale != m_OldScale ||
        m_Size != m_OldSize ||
        m_Rotation != m_OldRotation;
    }
  ```

### Sprite (class)
- Member Variables
    - ``` Material*   m_Material;                           ```
    - ``` TextureRect = The UVs of the Sprite for Animation ```
    - ``` Transform   m_Transform;                          ```
    - ``` Flags       = { HAS_ALPHA, FLIP_X, FLIP_Y }       ```

## Mid Level Renderer

### BufferUsage (enum class)
- (0x0) READBACK     - Buffer is used to store data from device operations such as screenshots, occlusion depth buffer _readback_, etc.
- (0x1) UPLOAD       - Buffer is used to upload dynamic geometry(, textures, uniforms, etc) as a staging buffer for _static_ **DEVICE_LOCAL** buffers.
- (0x2) DEVICE_LOCAL - Buffer is used to store data that needs to be efficiently fetched by the device: rendertargets, textures, (static) buffers.

### BufferType (enum class, flags)
- (0x1) VERTEX       - This type of buffer is used for storing vertex data for geometry.
- (0x2) INDEX        - This type of buffer is used for storing indices for which to draw the data.
- (0x4) UNIFORM      - This type of buffer is used for setting constants / uniforms to the shader.

### Buffer (class)
  - uint32_t    size();
  - BufferUsage usage();
  - BufferType  type();
  
### BufferHandle (class)
  - uint32_t    offset();
  - uint32_t    size();
  
### Render Commands

#### API Example
  ```cpp
  DrawItem* item = renderer->beginDrawItem(Material*)
  item->bindTransform(Transform*);
  item->bindMesh(MeshHandle);
  item->draw(firstVertex, numVertices);
  item->end();
  ```





















---
# Scripting

## API

## Low Level Implementation

- Bytecode Format
  - 32bits of awesome
```
0     5        14        23        32
[ooooo|aaaaaaaaa|bbbbbbbbb|ccccccccc]
[ooooo|aaaaaaaaa|bxbxbxbxbxbxbxbxbxb]
[ooooo|aaaaaaaaa|sBxbxbxbxbxbxbxbxbx]
opcode  =       0 -  32
rA      =       0 - 512
rB      =       0 - 512
rBx     =       0 - 262143
rsBx    = -131072 - 131071
rC      =       0 - 512
```

- Instruction Set (Max 32)

  - Load Instructions
    - LOAD_GLOBAL
      - rA = _G[rB]
    - LOAD_CONSTANT     (Numbers or Strings)
      - rA = K[rB]
    - LOAD_BOOLEAN
      - rA = (Boolean)B
      - if (C) PC++
    - LOAD_NULL
      - rA...(rA + B) = null
    - LOAD_OBJECT_KEY
      - rA = rB[rC]
    - LOAD_ARRAY_INDEX
      - rA = rB[rC]

  - Store Instructions
    - STORE_GLOBAL
      - rB[rC] = rA
    - STORE_ARRAY_INDEX
      - rB[rC] = rA
    - STORE_OBJECT_KEY
      - rB[rC] = rA
    - MOVE
      - rA = rB

  - Boolean Logic Instructions
    - CMP_LE 
    - CMP_LT 
    - CMP_EQ 
    - CMP_OR 
    - CMP_AND
    - LOGICAL_NOT
    
    - CMP_GT = (LOGICAL_NOT + CMP_LE)
    - CMP_GE = (LOGICAL_NOT + CMP_LT)

  - Arithmatic Instructions
    - ADD
    - SUB
    - DIV
    - MULT
    - MODULO
    - POW
    - UNARY_MINUS

  - System Instructions
    - MAKE_OBJECT
    - RETURN
    - PUSH_PARAM
    - TAIL_CALL
    - CALL
    - JUMP  
      - if ((rA & CPU_STATE) == CPU_STATE) PC += rsBx
    - GET_RETURN





































// Each  draw  item  is  a  very  compact  structure,  containing  state  IDs.
// XOR’ingtwo  draw  items  creates  a  bitmask  that  highlights  any  changes.
// Masking  out  sections  of  that  bitmask  and  comparing  them  to  zero  lets  you  quickly  check  if  a  state  has  changed  since  the  previous  draw  item.


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
# API Examples

SFML
```cpp
// create a 500x500 render-texture
sf::RenderTexture renderTexture;
if (!renderTexture.create(500, 500))
{
    // error...
}

// drawing uses the same functions
renderTexture.clear();
renderTexture.draw(sprite); // or any other drawable
renderTexture.display();

// get the target texture (where the stuff has been drawn)
const sf::Texture& texture = renderTexture.getTexture();

// draw it to the window
sf::Sprite sprite(texture);
window.draw(sprite);
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
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
# Notes and Additional Resources
- [Font Handling](http://www.angelcode.com/products/bmfont/)