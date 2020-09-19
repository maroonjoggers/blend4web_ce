.. index:: scene

.. _scene_settings:

**************
Scene Settings
**************

.. contents:: Table of Content
    :depth: 3
    :backlinks: entry

All the parameters that define the look and behavior of the whole scene (and not just a single object) are found on the three panels: the ``Render`` panel, the ``Scene`` panel and the ``World`` panel.

.. _render_settings:

Render Panel
============

.. image:: src_images/scene_settings/render.png
   :align: center
   :width: 100%

All scene parameters that concern the image rendering are found on this panel.


.. _render_reflections:

Reflections and Refractions
---------------------------

Reflection and refraction effect settings.

.. image:: src_images/scene_settings/render_reflections_and_refractions.png
   :align: center
   :width: 100%

*Reflection*
    Reflection effect settings. Can be set to ``ON``, ``OFF`` or ``AUTO``. Set to ``ON`` by default.

*Refraction*
    Refraction effect settings. Can be set to ``ON``, ``OFF`` or ``AUTO``. Set to ``AUTO`` by default.

*Quality*
    Quality settings for the reflection effect. Can be set to ``HIGH`` (the highest reflection quality), ``MEDIUM`` (medium quality) or to ``LOW`` (the lowest quality). Set to ``MEDIUM`` by default.

.. _render_motion_blur:

Motion Blur
-----------

Motion blur settings. Described thoroughly :ref:`in its own section <motion_blur>`.

.. image:: src_images/scene_settings/render_motion_blur.png
   :align: center
   :width: 100%


.. _render_bloom:

Bloom
-----

Bloom effect settings. Described thoroughly in :ref:`its own section <bloom>`.

.. image:: src_images/scene_settings/render_bloom.png
   :align: center
   :width: 100%


.. _render_color_correction:

Color Correction
----------------

Color correction settings. Described thoroughly in :ref:`its own section <color_correction>`.

.. image:: src_images/scene_settings/render_color_correction.png
   :align: center
   :width: 100%


.. _render_glow_materials:

Glow Materials
--------------

Glow Material effect settings. Described thoroughly in :ref:`its own section <glow>`.

.. image:: src_images/scene_settings/render_glow_materials.png
   :align: center
   :width: 100%


.. _render_object_outlining:

Object Outlining
----------------

Outlining effect settings. Described thoroughly in :ref:`its own section<outline>`.

.. image:: src_images/scene_settings/render_object_outlining.png
   :align: center
   :width: 100%


.. _render_ssao:

Ambient Occlusion (SSAO)
------------------------

Screen-space ambient occlusion (SSAO) settings. Described thoroughly in :ref:`its own section <ssao>`.

.. image:: src_images/scene_settings/render_ambient_occlusion.png
   :align: center
   :width: 100%


.. _render_god_rays:

God Rays
--------

God Rays effect settings. Described thoroughly in :ref:`its own section <god_rays>`.

.. image:: src_images/scene_settings/render_god_rays.png
   :align: center
   :width: 100%


.. _render_anti_aliasing:

Anti-Aliasing
-------------

Anti-Aliasing settings. Described thoroughly in :ref:`its own section<antialiasing>`.

.. image:: src_images/scene_settings/render_anti_aliasing.png
   :align: center
   :width: 100%


.. _render_shadows:

Shadows
-------

Shadows settings. Described thoroughly in :ref:`its own section<shadows>`.

.. image:: src_images/scene_settings/render_shadows.png
   :align: center
   :width: 100%

.. _render_development_server:

Development Server
------------------

Development Server settings. Described thoroughly in :ref:`its own section <local_development_server>`.

.. image:: src_images/scene_settings/render_development_server.png
   :align: center
   :width: 100%

.. _render_timeline:

Timeline
--------

Timeline settings.

.. image:: src_images/scene_settings/render_timeline.png
   :align: center
   :width: 100%

*Start Frame*
    The first frame of the timeline. Set to 1 by default.

*End Frame*
    The last frame of the timeline. Set to 250 by default.

*Frame Rate*
    Number of the frames per second. Set to 24 by default. This parameter only affect the animation playback speed (not the scene itself).

.. _scene:

Scene Panel
===========

.. image:: src_images/scene_settings/scene.png
   :align: center
   :width: 100%

The settings that concern scene behavior, including audio, physics and animation settings, are found on this panel.

.. _scene_scene:

Scene
-----

Scene settings.

.. image:: src_images/scene_settings/scene_scene.png
   :align: center
   :width: 100%

*Camera*
    A camera that is used to render the scene.

.. _scene_units:

Units
-----

Sets the measurement units used in the scene.

.. image:: src_images/scene_settings/scene_units.png
   :align: center
   :width: 100%

.. _scene_audio:

Audio
-----

Audio settings.

.. image:: src_images/scene_settings/scene_audio.png
   :align: center
   :width: 100%

*Volume*
    The master volume of the sound in the application. This value can vary between 0 and 100. Default value is 1.0.

*Distance Model*
    The distance model used for calculating distance attenuation. Following models are supported by the engine:

    ``None`` - no distance model is used, the sound has constant volume regardless of the distance.

    ``Exponent Clamped`` - a clamped exponential distance model.

    ``Linear Clamped`` - a clamped linear distance model.

    ``Inverse Clamped`` - a clamped inverse distance model.

    The following models are partially supported (work the same way the corresponding *Clamped*-type models):

    ``Exponent``

    ``Linear``

    ``Inverse``

    This parameter is set to ``Inverse Clamped`` by default.

*Speed*
    This parameter sets the speed of sound used for Doppler effect calculation. Its value is measured in meters per second and is set to 343.3 by default.

*Doppler*
    This sets the pitch factor for Doppler effect calculation. Its default value if 1.0.

*Dynamic Compressor*
    Compress audio signal's dynamic range. This feature can be used to make the sound more rich and even. Disabled by default.

*Threshold*
    If the amplitude of the audio signal exceeds the value specified by this parameter, the compressor will reduce its level. Set to -24 dB by default.

*Knee*
    The interval below the threshold where the response curve switches to the decreasing mode. Set to 30 by default.

*Ratio*
    Amount of gain reduction. Set to 12 by default.

*Attack*
    Time (in seconds) that takes the compressor to reduce gain by 10 dB. Set to 0.003 by default.

*Release*
    Time (in seconds) that takes the compressor to increase gain by 10 dB. Set to 0.25 by default.

.. _scene_logic_editor:

Logic Editor
------------

Settings for the use of the logic node trees (created in the :ref:`logic editor <logic_editor>`) in the scene. Disabled by default.

.. image:: src_images/scene_settings/scene_logic_editor.png
   :align: center
   :width: 100%

*Active Node Tree*
    Node tree that is used in the scene's playback.

.. _scene_nla:

NLA
---

Non-Linear Animation playback settings. Disabled by default.

.. image:: src_images/scene_settings/scene_nla.png
   :align: center
   :width: 100%

*Cyclic NLA*
    If this parameter is enabled, NLA animation will be repeated after it is finished.

.. _scene_meta_tags:

Meta Tags
---------

Application's meta tags.

.. image:: src_images/scene_settings/scene_meta_tags.png
   :align: center
   :width: 100%

*Title*
    The title of the application.

*Description*
    The description of the application. Can be a simple text or a link to a text file (if the ``Description Source`` parameter is set to the ``File`` value).

*Description Source*
    The source of the application's description. The description can be loaded from a file or specified directly in the ``Description`` field. This parameter can have one of the two values, ``Text`` and ``File``, and it is set to ``Text`` by default.

.. _scene_physics:

Physics
-------

Physics settings.

.. image:: src_images/scene_settings/scene_physics.png
   :align: center
   :width: 100%

*Enable Physics*
    Allow using physics in the application. Enabled by default.

.. _scene_batching:

Cluster Batching
----------------

This parameter enables the use of cluster batching. It can be used for optimization purposes. This is disabled by default.

.. note::
    If this parameter is disabled, the engine will try to combine all static objects into one.

.. image:: src_images/scene_settings/scene_cluster_batching.png
   :align: center
   :width: 100%

*Cluster Size*
    The size of the cluster used for batching (in meters). Set to 30 by default. If this parameter is set to zero, objects will not be combined.

.. _scene_objects_selection:

Objects Selection
-----------------

Object selection settings. Objects can be selected both with the API function :b4wref:`scenes.pick_object()` and with the :ref:`logic nodes <logic_editor>`.

.. note::
    In the :ref:`scene viewer <viewer>`, selection is enabled by default. You can turn it off in the ``Tools & Debug`` panel.

.. image:: src_images/scene_settings/scene_objects_selection.png
   :align: center
   :width: 100%

*Enable*
    The parameter that defines if the object can or can't be selected. It can have ``ON``, ``OFF`` or ``AUTO`` value. Set to ``AUTO`` by default.

.. _scene_anchors:

Anchors
-------

:ref:`Anchor <objects_anchors>` visibility detection settings.

.. image:: src_images/scene_settings/scene_anchors.png
   :align: center
   :width: 100%

*Detect Anchors Visibility*
    Anchor visibility detection parameter. Can have ``ON``, ``OFF`` or ``AUTO`` value. Set to ``AUTO`` by default.

.. _scene_export_options:

Export Options
--------------

Scene settings export parameters.

.. image:: src_images/scene_settings/scene_export_options.png
   :align: center
   :width: 100%

*Do Not Export*
    If this parameter is enabled, scene settings will be ignored during export.

.. _world_settings:

World Panel
===========

.. image:: src_images/scene_settings/world.png
   :align: center
   :width: 100%

Environment settings such as settings for sky, mist and such are found on this panel.

.. _world_preview:

Preview
-------

Environment preview.

.. image:: src_images/scene_settings/world_preview.png
   :align: center
   :width: 100%

.. _world_world:

World
-----

Sky settings.

.. image:: src_images/scene_settings/world_world.png
   :align: center
   :width: 100%

*Render Sky*
    If this parameter is enabled, the engine will render sky in the scene.

*Paper Sky*
    If this parameter is enabled, sky gradient will always be drawn from the top of the screen to the bottom, regardless of the camera's position and angles.

*Blend Sky*
    Smooth transition between the horizon and zenith colors.

*Real Sky*
    Sky rendering with the horizon affected by the camera angle.

*Horizon Color*
    Sky color at the horizon.

*Zenith Color*
    Sky color in the zenith.

*Ambient Color*
    The color of the ambient lighting.

*Reflect World*
    Render the sky while rendering reflections.

*Render Only Reflection*
    Render the sky *only* while rendering reflections.

.. _world_environment_lighting:

Environment Lighting
--------------------

Environment lighting settings. Described thoroughly in :ref:`their own section <environment_lighting>`.

.. image:: src_images/scene_settings/world_environment_lighting.png
   :align: center
   :width: 100%


.. _world_mist:

Mist
----

Mist settings.

.. image:: src_images/scene_settings/world_mist.png
   :align: center
   :width: 100%

*Minimum*
    Minimum intensity of the mist. Set to zero by default.

*Depth*
    At this distance from the camera the mist effect reaches maximum intensity. Set to 25 by default.

*Start*
    The mist effect starts to appear at this distance from the camera. Set to 5 by default.

*Height*
    This parameter specifies how fast mist intensity decreases as the camera's altitude increases. Set to 0 by default.

*Fall Out*
    This parameter specifies the rule, according to which the density of the mist changes between the borders (specified by the ``Start`` and ``Depth`` parameters). Can have one of the following values: ``Quadratic``, ``Linear``,  ``Inverse Quadratic``. Set to ``Quadratic`` by default.

*Use Custom Colors*
    Can be used to set the color of the mist. Enabled by default. If this parameter is disabled, standard (0.5, 0.5, 0.5) color will be used.

*Fog Color*
    The color of the mist. Can be changed, if the ``Use custom colors`` parameter is enabled. Light gray (0.5, 0.5, 0.5) color is used by default.

.. _world_procedural_sky:

Procedural Sky
--------------

    Procedural sky settings. Described thoroughly in :ref:`their own section<atmosphere>`.

.. image:: src_images/scene_settings/world_procedural_sky.png
   :align: center
   :width: 100%


.. _world_export_options:

Export Options
--------------

Environment parameters export settings.

.. image:: src_images/scene_settings/world_export_options.png
   :align: center
   :width: 100%

*Do Not Export*
    If this parameter is enabled, environment settings will be ignored during the export.
