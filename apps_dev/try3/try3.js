"use strict"

// register the application module
b4w.register("try3", function(exports, require) {

// import modules used by the app
var m_app       = require("app");
var m_cfg       = require("config");
var m_data      = require("data");
var m_preloader = require("preloader");
var m_ver       = require("version");
var m_scs       = require("scenes");
var m_trans     = require("transform");
var m_phys      = require("physics");
var m_quat      = require("quat");

// detect application mode
var DEBUG = (m_ver.type() == "DEBUG");

// automatically detect assets path
var APP_ASSETS_PATH = m_cfg.get_std_assets_path() + "try3/";

/**
 * export the method to initialize the app (called at the bottom of this file)
 */
exports.init = function() {
    m_app.init({
        canvas_container_id: "main_canvas_container",
        callback: init_cb,
        show_fps: DEBUG,
        console_verbose: DEBUG,
        autoresize: true,
        physics_enabled: false
    });
}

/**
 * callback executed when the app is initialized
 */
function init_cb(canvas_elem, success) {

    if (!success) {
        console.log("b4w init failure");
        return;
    }

    m_preloader.create_preloader();

    // ignore right-click on the canvas element
    canvas_elem.oncontextmenu = function(e) {
        e.preventDefault();
        e.stopPropagation();
        return false;
    };

    load();
}

/**
 * load the scene data
 */
function load() {
    m_data.load(APP_ASSETS_PATH + "bluebirdTut24.json", load_cb, preloader_cb);
}

/**
 * update the app's preloader
 */
function preloader_cb(percentage) {
    m_preloader.update_preloader(percentage);
}

/**
 * callback executed when the scene data is loaded
 */
function load_cb(data_id, success) {

    if (!success) {
        console.log("b4w load failure");
        return;
    }


    m_app.enable_camera_controls();

    // place your code here
    create_slider();

    var my_slider = document.getElementById("slider_id");
    var car = m_scs.get_object_by_name("bluebird");

    //m_app.enable_object_controls(car)
    m_trans.set_translation(car, 0, 0.64, my_slider.value/25);

    // Update the current slider value (each time you drag the slider handle)
    my_slider.oninput = function() {
        m_trans.set_translation(car, 0, 0.64, this.value/25);
    }

}

function create_slider() {
    var slider = document.createElement("INPUT");
    slider.id = "slider_id";
    slider.setAttribute("type", "range");
    slider.setAttribute("min", "-50");
    slider.setAttribute("max", "50");
    slider.setAttribute("value", "0");
    slider.style.position = "relative";
    slider.style.width = "33%";
    document.body.appendChild(slider);
}

});

// import the app module and start the app by calling the init method
b4w.require("try3").init();
