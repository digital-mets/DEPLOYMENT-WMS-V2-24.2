import * as THREE from 'three';
import * as TWEEN from '@tweenjs/tween.js';
import { MapControls } from 'OrbitControls';
import { Sky } from 'Sky';
import Stats from 'Stats';


//================================
let scene, camera, renderer, controls, stats;
let light, color, intensity;
let sky, sun;

//let planeHeight = 120, planeWidth = 60;
let planeHeight = 120, planeWidth = 60;
let planeSize = 60, planeDivision, rolloverPlaneSize;

let canvasHeight, canvasWidth;

// Floor
let floorGeometry, floorMaterial, floorMesh;

// Raycaster
let raycaster = new THREE.Raycaster();
let pointer = new THREE.Vector2();

let isCtrlDown = false, isShiftDown = false;

let plane;
let rollOverMesh, rollOverMaterial;
let cubeGeo, cubeMaterial;

const bufferGroup = new THREE.Group();

let activeObject = "Rack";


let intersects;

let count = 0;

let objects = [];

let activeTool = "default";

let initSizeVector = new THREE.Vector3();
let lastSizeVector = new THREE.Vector3();
let finalScale = new THREE.Vector3();


const group = new THREE.Group();

// Vars for drawing direction of voxels
let startPos = new THREE.Vector3();
let endPos = new THREE.Vector3();
let dirVector = new THREE.Vector3();
let direction = "";

function init() {
    // Scene
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0xedf1f5);
    //scene.fog = new THREE.FogExp2(0xefd1b5, 0.0025);

    let element = document.getElementById('main');

    // Get the height and width of the element
    canvasHeight = element.clientHeight;
    canvasWidth = element.clientWidth;

    // Camera
    camera = new THREE.PerspectiveCamera(35, canvasWidth / canvasHeight, 0.1, 1000);
    camera.position.set(0, 125, 0);

    // Renderer
    renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    renderer.setSize(canvasWidth, canvasHeight);
    document.getElementById("main").appendChild(renderer.domElement);

    // Controls
    controls = new MapControls(camera, renderer.domElement);
    controls.target.set(0, 0.5, 0);
    controls.update();
    controls.minPolarAngle = THREE.MathUtils.degToRad(0);
    controls.maxPolarAngle = THREE.MathUtils.degToRad(90);
    controls.minDistance = 10;
    controls.maxDistance = 1000;
    //controls.enablePan = false;

    // Floor
    floorGeometry = new THREE.PlaneGeometry(10000, 10000)
    floorMaterial = new THREE.MeshLambertMaterial({
        color: "#8c8c8c"
    })
    floorMesh = new THREE.Mesh(floorGeometry, floorMaterial)
    floorMesh.position.set(0, -0.5, 0)
    floorMesh.rotation.set(Math.PI / -2, 0, 0)
    //scene.add(floorMesh)
    group.add(floorMesh)
    floorMesh.name = "floorMesh";

    // Ground Plane
    planeDivision = (planeHeight * planeWidth) / 2;
    rolloverPlaneSize = (planeHeight * planeWidth) / planeDivision;

    const geometry = new THREE.PlaneGeometry(planeHeight, planeWidth);
    geometry.rotateX(- Math.PI / 2);
    plane = new THREE.Mesh(geometry, new THREE.MeshBasicMaterial({ color: "#ffffff" }));
    plane.position.set(0, 0.01, 0)
    //scene.add(plane);
    group.add(plane);
    plane.name = "ground";

    customGridHelper({
        height: planeHeight / 2,
        width: planeWidth / 2,
        linesHeight: planeHeight / 2,
        linesWidth: planeWidth / 2,
        color: 0x000000
    });

    // Default Cube
    cubeGeo = new THREE.BoxGeometry(rolloverPlaneSize, rolloverPlaneSize, rolloverPlaneSize);
    //cubeMaterial = new THREE.MeshLambertMaterial({ color: 0xddd9cc });
    cubeMaterial = new THREE.MeshLambertMaterial({ color: 0x00ff00 });



    // Rollover
    const rollOverGeo = new THREE.PlaneGeometry(rolloverPlaneSize, rolloverPlaneSize);
    rollOverMaterial = new THREE.MeshBasicMaterial({ color: 0x57f781, opacity: 0.5, transparent: true });
    rollOverMesh = new THREE.Mesh(rollOverGeo, rollOverMaterial);
    rollOverMesh.position.set(rolloverPlaneSize / 2, 0.11, -rolloverPlaneSize / 2)
    rollOverMesh.rotateX(- Math.PI / 2);
    //scene.add(rollOverMesh);
    group.add(rollOverMesh);
    rollOverMesh.name = "rolloverMesh";
    rollOverMesh.visible = false;

    // Sky
    initSky();

    // Lights
    lights();

    // Stats
    stats = new Stats();

    let thisParent = document.getElementById("stats");
    thisParent.appendChild(stats.dom);

    let childElement = document.querySelector('#stats div');
    childElement.style.position = 'relative';
    // End Stats

    // Events
    //draw();

    initDragWindow();

    document.addEventListener('keydown', onDocumentKeyDown);
    document.addEventListener('keyup', onDocumentKeyUp);

    window.addEventListener('resize', onWindowResize, false);

    // DOM Events
    $("#btnReset").click(function () {
        resetCamera();
    });

    $("#pointer-tool").click(function () {
        setActiveTool('default');
    });

    $("#draw-tool").click(function () {
        setActiveTool('draw');
    });

    $("#erase-tool").click(function () {
        setActiveTool('erase');
    });

    $("#clearAll").click(function () {
        setActiveTool('clear');
    });

    $(function () {
        $('[data-toggle="tooltip"]').tooltip({ boundary: 'window', trigger: "hover" })
    });

    $(".ui-elem").hover(
        function () {
            setActiveTool("default");
        },
        function () {
            setActiveTool(activeTool);
        }
    );



    // Add group to scene
    scene.add(group);
    group.name = "sceneInit"


    scene.add(bufferGroup);
    //console.log(group.children);

    // Temporary
    //window.onbeforeunload = function () {
    //    return "Data will be lost if you leave the page, are you sure?";
    //};

    //$(window).keypress(function (event) {
    //    if (!(event.which == 115 && event.ctrlKey) && !(event.which == 19)) return true;
    //    alert("Ctrl-S pressed");
    //    event.preventDefault();
    //    return false;
    //});

    document.addEventListener('keydown', e => {
        

        if (e.ctrlKey && (e.key === 's' || e.key === 'S')) {
            // Prevent the Save dialog to open
            e.preventDefault();
            // Place your code here
            console.log('CTRL + S');
            alert('CTRL + S');
        }
        

        if (e.ctrlKey && (e.key === 'o' || e.key === 'O')) {
            // Prevent the Save dialog to open
            e.preventDefault();
            // Place your code here
            console.log('CTRL + O');
            alert('CTRL + O');
        }

        if (e.shiftKey && (e.key === 'd' || e.key === 'D')) {
            e.preventDefault();
            setActiveTool('draw');
        }

        if (e.shiftKey && (e.key === 'e' || e.key === 'E')) {
            e.preventDefault();
            setActiveTool('erase');
        }
    });
}

function customGridHelper(opts) {
    var config = opts || {
        height: 60,
        width: 30,
        linesHeight: 60,
        linesWidth: 30,
        color: 0x000000
    };

    const points = [];

    var material = new THREE.LineBasicMaterial({
        color: config.color,
        transparent: true,
        opacity: 0.2
    });

    var gridObject = new THREE.Object3D();
    var stepw = 2 * config.width / config.linesWidth;
    var steph = 2 * config.height / config.linesHeight;

    // Add horizontal lines
    for (var i = -config.height; i <= config.height; i += steph) {
        points.push(new THREE.Vector3(-config.width, i, 0));
        points.push(new THREE.Vector3(config.width, i, 0));
    }

    // Add vertical lines
    for (var i = -config.width; i <= config.width; i += stepw) {
        points.push(new THREE.Vector3(i, -config.height, 0));
        points.push(new THREE.Vector3(i, config.height, 0));
    }

    var gridGeo = new THREE.BufferGeometry().setFromPoints(points);
    var line = new THREE.LineSegments(gridGeo, material);

    gridObject.add(line);
    //scene.add(gridObject);
    group.add(gridObject);
    gridObject.name = "customGridHelper"
    gridObject.rotateX(-Math.PI / 2);
    gridObject.rotateZ(-Math.PI / 2);
    gridObject.position.y += 0.011;
}

function setActiveTool(tool) {
    $(document).unbind('mousedown');
    $(document).unbind('pointermove');

    activeTool = tool;

    initRaycaster();
}

function initRaycaster() {
    $(document).on('pointermove', function (event) {
        pointer.x = (event.clientX / canvasWidth) * 2 - 1;
        pointer.y = - (event.clientY / canvasHeight) * 2 + 1;

        raycaster.setFromCamera(pointer, camera);
        //intersects = raycaster.intersectObjects(objects, scene.children);
        intersects = raycaster.intersectObjects(scene.children);
        intersects.forEach(function (intersect) {
            //console.log(intersect.object[0]);

            if (intersect.object.name === "ground") {
                if (direction) {
                    if (direction.includes("horizontal")) {
                        const rollOverPos = new THREE.Vector3().copy(intersect.point).divideScalar(2).floor().multiplyScalar(2).addScalar(1);
                        rollOverMesh.position.set(rollOverPos.x, 0.011, startPos.z);
                    }
                    if (direction.includes("vertical")) {
                        const rollOverPos = new THREE.Vector3().copy(intersect.point).divideScalar(2).floor().multiplyScalar(2).addScalar(1);
                        rollOverMesh.position.set(startPos.x, 0.011, rollOverPos.z);
                    }
                }
                else {
                    const rollOverPos = new THREE.Vector3().copy(intersect.point).divideScalar(2).floor().multiplyScalar(2).addScalar(1);
                    rollOverMesh.position.set(rollOverPos.x, 0.011, rollOverPos.z);
                }
                //const rollOverPos = new THREE.Vector3().copy(intersect.point).divideScalar(2).floor().multiplyScalar(2).addScalar(1);
                //rollOverMesh.position.set(rollOverPos.x, 0.011, rollOverPos.z);
            }
        });
    });
}

function pointerTool() {
    $('canvas').css('cursor', 'default');

    rollOverMesh.visible = false;

    controls.enablePan = true;
}

let drawing = false;

function drawTool3(objectType) {
    $('canvas').css('cursor', 'crosshair');

    rollOverMesh.visible = true;
    rollOverMesh.material.color.setHex(0x57f781);
    controls.enablePan = false;

    $(document).on('mousedown', function (e) {

        if (!isShiftDown) {
            if (intersects.length > 0) {
                drawing = true;

                const objExist = objects.find(function (object) {
                    return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                });
                if (!objExist) {
                    intersects.forEach(function (intersect) {
                        if (intersect.object.name === "ground") {
                            startPos = { x: rollOverMesh.position.x, y: 1, z: rollOverMesh.position.z };


                            drawPlaceholderMesh2(startPos);
                        }
                    });
                }
            }

            animate;

            $(this).mousemove(function () {
                const objExist = objects.find(function (object) {
                    return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                });
                if (!objExist) {
                    intersects.forEach(function (intersect) {
                        if (intersect.object.name === "ground") {

                            dirVector = { x: rollOverMesh.position.x, y: 1, z: rollOverMesh.position.z };

                            direction = drawDirection(startPos, dirVector);
                            endPos = { x: rollOverMesh.position.x, y: 1, z: rollOverMesh.position.z };

                            if (direction) {
                                if (direction.includes("horizontal")) {
                                    drawPlaceholderMesh2({ x: rollOverMesh.position.x, y: 1, z: startPos.z });
                                }

                                if (direction.includes("vertical")) {
                                    drawPlaceholderMesh2({ x: startPos.x, y: 1, z: rollOverMesh.position.z });
                                }
                            }
                        }

                    });
                }

                animate;
            });
        }
    }).mouseup(function () {
        endDraw();
        //$(this).unbind('mousemove');

        //direction = "";
        //drawing = false;

        //endPos = { x: 0, y: 0, z: 0 };
        //bufferGroup.clear();
        //objects = [];
        //count = 0;



    }).mouseout(function () {
        endDraw();
        //$(this).unbind('mousemove');

        //direction = "";
        //drawing = false;

        //endPos = { x: 0, y: 0, z: 0 };
        //bufferGroup.clear();
        //objects = [];
        //count = 0;


    });
}

function endDraw() {
    $(document).unbind('mousemove');

    if (drawing) {
        drawMesh();
    }

    direction = "";
    drawing = false;

    

    endPos = { x: 0, y: 0, z: 0 };
    bufferGroup.clear();
    objects = [];
    count = 0;
}

function drawPlaceholderMesh2(posVector) {
    
    const voxel = new THREE.Mesh(cubeGeo, cubeMaterial);
    if (bufferGroup.children.length == 0) {
        voxel.position.copy(posVector);
        
        bufferGroup.add(voxel);

        objects.push(voxel);
        voxel.name = "box" + count;

        count = count + 1;
    } else {
        const boxx = bufferGroup.children[0];
        
        if (direction === "horizontalPos") {

            initSizeVector.subVectors(endPos, startPos);
            if (initSizeVector.x > 0) {
                boxx.position.x = (startPos.x - 1) + (initSizeVector.x * 0.5);
                boxx.scale.x = initSizeVector.x * 0.5;
            } else {
                boxx.position.x = startPos.x;
                boxx.scale.x = 1;

            }

        }
        else if (direction === "horizontalNeg") {
            initSizeVector.subVectors(startPos, endPos);
            if (initSizeVector.x > 0) {
                boxx.position.x = (endPos.x + 1) + (initSizeVector.x * 0.5);
                boxx.scale.x = initSizeVector.x * 0.5;
            } else {
                boxx.position.x = startPos.x;
                boxx.scale.x = 1;
            }
        }
        else if (direction === "verticalPos") {
            initSizeVector.subVectors(startPos, endPos);
            if (initSizeVector.z > 0) {
                boxx.position.z = (startPos.z + 1) - (initSizeVector.z * 0.5);
                boxx.scale.z = initSizeVector.z * 0.5;
            } else {
                boxx.position.z = startPos.z;
                boxx.scale.z = 1;

            }
        }
        else if (direction === "verticalNeg") {
            initSizeVector.subVectors(endPos, startPos);
            if (initSizeVector.z > 0) {
                boxx.position.z = (startPos.z - 1) + (initSizeVector.z * 0.5);
                boxx.scale.z = initSizeVector.z * 0.5;
            } else {
                boxx.position.z = startPos.z;
                boxx.scale.z = 1;

            }
        }
        //else if (direction === "horizontalNeg") {
        //    initSizeVector.subVectors(startPos, endPos);

        //    boxx.position.x = (endPos.x + 1) + (initSizeVector.x * 0.5);
        //    boxx.scale.x = initSizeVector.x * 0.5;
        //}

        //boxx.scale.x = lastSizeVector.x;
        //boxx.scale.z = lastSizeVector.z;


    }
}

// Straight lines
function drawTool2(objectType) {
    $('canvas').css('cursor', 'crosshair');

    rollOverMesh.visible = true;
    rollOverMesh.material.color.setHex(0x57f781);
    controls.enablePan = false;

    $(document).on('mousedown', function (e) {

        if (!isShiftDown) {
            if (intersects.length > 0) {
                drawing = true;

                const objExist = objects.find(function (object) {
                    return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                });
                if (!objExist) {
                    intersects.forEach(function (intersect) {
                        if (intersect.object.name === "ground") {
                            startPos = { x: rollOverMesh.position.x, y: 1, z: rollOverMesh.position.z };


                            drawPlaceholderMesh(startPos);
                        }
                    });
                }
            }

            animate;

            $(this).mousemove(function () {
                const objExist = objects.find(function (object) {

                    return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                });
                if (!objExist) {
                    intersects.forEach(function (intersect) {
                        if (intersect.object.name === "ground") {

                            dirVector = { x: rollOverMesh.position.x, y: 1, z: rollOverMesh.position.z };

                            direction = drawDirection(startPos, dirVector);
                            endPos = { x: rollOverMesh.position.x, y: 1, z: rollOverMesh.position.z };

                            if (direction) {
                                if (direction.includes("horizontal")) {
                                    drawPlaceholderMesh({ x: rollOverMesh.position.x, y: 1, z: startPos.z });
                                }

                                if (direction.includes("vertical")) {
                                    drawPlaceholderMesh({ x: startPos.x, y: 1, z: rollOverMesh.position.z });
                                }
                            }
                        }

                    });
                }

                animate;
            });
        }
    }).mouseup(function () {
        $(this).unbind('mousemove');

        if (drawing) {
            drawMesh();
        }

        direction = "";
        drawing = false;



    }).mouseout(function () {
        $(this).unbind('mousemove');

        direction = "";
        drawing = false;

        if (drawing) {
            drawMesh();
        }
    });
}

function drawPlaceholderMesh(posVector) {
    const voxel = new THREE.Mesh(cubeGeo, cubeMaterial);

    voxel.position.copy(posVector);

    //scene.add(voxel);
    bufferGroup.add(voxel);

    objects.push(voxel);
    voxel.name = "box" + count;

    console.log(voxel.name);

    count = count + 1;
}

function drawMesh() {
    if (drawing) {
        if (endPos.x === 0 || endPos.z === 0) {
            const cubeGeo = new THREE.BoxGeometry(rolloverPlaneSize, rolloverPlaneSize, rolloverPlaneSize);
            const cubeMaterial = new THREE.MeshLambertMaterial({ color: 0x0000ff });

            const cubeMesh = new THREE.Mesh(cubeGeo, cubeMaterial);

            cubeMesh.position.copy({ x: rollOverMesh.position.x, y: 1.01, z: rollOverMesh.position.z });
            scene.add(cubeMesh);
        } else {
            if (direction) {
                if (direction.includes("horizontal")) {
                    let sizeVector = new THREE.Vector3();
                    let startVector = new THREE.Vector3();

                    let xVal = 0;

                    if (direction === "horizontalNeg") {
                        startPos.x = startPos.x + 1;
                        endPos.x = endPos.x - 1;
                        sizeVector.subVectors(endPos, startPos);
                        console.log(sizeVector);
                        xVal = sizeVector.x;
                    }

                    if (direction === "horizontalPos") {
                        startPos.x = startPos.x - 1;
                        endPos.x = endPos.x + 1;
                        sizeVector.subVectors(startPos, endPos);
                        xVal = Math.abs(sizeVector.x);
                    }

                    // draw cube
                    const cubeGeo = new THREE.BoxGeometry(Math.abs(sizeVector.x), 2, 2);
                    const cubeMaterial = new THREE.MeshLambertMaterial({ color: 0x0000ff });

                    const cubeMesh = new THREE.Mesh(cubeGeo, cubeMaterial);

                    sizeVector.x = xVal * .5;

                    startVector.addVectors(startPos, sizeVector);
                    startVector.y = 1.01;
                    cubeMesh.position.copy(startVector);
                    scene.add(cubeMesh);

                } else if (direction.includes("vertical")) {
                    let sizeVector = new THREE.Vector3();
                    let startVector = new THREE.Vector3();

                    let zVal = 0;
                    if (direction === "verticalNeg") {
                        startPos.z = startPos.z - 1;
                        endPos.z = endPos.z + 1;
                        sizeVector.subVectors(endPos, startPos);
                        zVal = sizeVector.z;
                    }

                    if (direction === "verticalPos") {
                        startPos.z = startPos.z + 1;
                        endPos.z = endPos.z - 1;
                        sizeVector.subVectors(endPos, startPos);
                        zVal = sizeVector.z;
                    }

                    // draw cube
                    const cubeGeo = new THREE.BoxGeometry(2, 2, Math.abs(sizeVector.z));
                    const cubeMaterial = new THREE.MeshLambertMaterial({ color: 0x0000ff });

                    const cubeMesh = new THREE.Mesh(cubeGeo, cubeMaterial);

                    sizeVector.z = zVal * .5;

                    startVector.addVectors(startPos, sizeVector);
                    startVector.y = 1.01;

                    cubeMesh.position.copy(startVector);
                    scene.add(cubeMesh);
                } else {
                    // Clear
                    endPos = { x: 0, y: 0, z: 0 };
                    bufferGroup.clear();
                    objects = [];
                    count = 0;
                }
            } else {
                const cubeGeo = new THREE.BoxGeometry(rolloverPlaneSize, rolloverPlaneSize, rolloverPlaneSize);
                const cubeMaterial = new THREE.MeshLambertMaterial({ color: 0x0000ff });

                const cubeMesh = new THREE.Mesh(cubeGeo, cubeMaterial);

                cubeMesh.position.copy(startPos);
                scene.add(cubeMesh);
            }


        }

        // Clear
        endPos = { x: 0, y: 0, z: 0 };
        bufferGroup.clear();
        objects = [];
        count = 0;
    }


}

function drawDirection(startPos, dirVector) {
    let drawDir;

    let vectorC = new THREE.Vector3();

    vectorC.subVectors(startPos, dirVector);

    if (vectorC.x != 0 && startPos.z == dirVector.z) {
        //drawDir = "horizontal";
        if (vectorC.x < 0) {
            drawDir = "horizontalPos";
        } else if (vectorC.x > 0) {
            drawDir = "horizontalNeg";
        }
    } else if (vectorC.z != 0 && startPos.x == dirVector.x) {
        //drawDir = "vertical";
        if (vectorC.z > 0) {
            drawDir = "verticalPos";
        } else if (vectorC.z < 0) {
            drawDir = "verticalNeg";
        }
    } else { direction = ""; }

    if (direction === "") {
        return drawDir;
    } else {
        return direction;
    }
}


function drawTool(objectType) {
    $('canvas').css('cursor', 'crosshair');

    rollOverMesh.visible = true;
    rollOverMesh.material.color.setHex(0x57f781);
    controls.enablePan = false;


    //$(document).on('pointermove', function (event) {
    //    pointer.x = (event.clientX / canvasWidth) * 2 - 1;
    //    pointer.y = - (event.clientY / canvasHeight) * 2 + 1;

    //    raycaster.setFromCamera(pointer, camera);
    //    //intersects = raycaster.intersectObjects(objects, scene.children);
    //    intersects = raycaster.intersectObjects(scene.children);
    //    intersects.forEach(function (intersect) {
    //        if (intersect.object.name === "ground") {
    //            const rollOverPos = new THREE.Vector3().copy(intersect.point).divideScalar(2).floor().multiplyScalar(2).addScalar(1);
    //            rollOverMesh.position.set(rollOverPos.x, 0.011, rollOverPos.z);
    //        }
    //    });
    //});

    $(document).on('mousedown', function (e) {

        if (!isShiftDown) {
            if (intersects.length > 0) {

                const objExist = objects.find(function (object) {
                    return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                });
                if (!objExist) {
                    intersects.forEach(function (intersect) {
                        if (intersect.object.name === "ground") {
                            const voxel = new THREE.Mesh(cubeGeo, cubeMaterial);

                            voxel.position.set(rollOverMesh.position.x, 1, rollOverMesh.position.z)

                            scene.add(voxel);

                            objects.push(voxel);
                            voxel.name = "box" + count;

                            count = count + 1;
                        }
                    });
                }
            }

            animate;

            $(this).mousemove(function () {

                const objExist = objects.find(function (object) {
                    return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                });
                if (!objExist) {
                    intersects.forEach(function (intersect) {
                        if (intersect.object.name === "ground") {
                            const voxel = new THREE.Mesh(cubeGeo, cubeMaterial);

                            voxel.position.set(rollOverMesh.position.x, 1, rollOverMesh.position.z)

                            scene.add(voxel);

                            objects.push(voxel);
                            voxel.name = "box" + count;

                            count = count + 1;
                        }
                    });
                }

                animate;
            });
        }
    }).mouseup(function () {
        $(this).unbind('mousemove');
    }).mouseout(function () {
        $(this).unbind('mousemove');
    });
}

function eraseTool() {
    $('canvas').css('cursor', 'crosshair');

    rollOverMesh.visible = true;
    rollOverMesh.material.color.setHex(0xf75757);

    controls.enablePan = false;


    //$(document).on('pointermove', function (event) {
    //    pointer.x = (event.clientX / canvasWidth) * 2 - 1;
    //    pointer.y = - (event.clientY / canvasHeight) * 2 + 1;

    //    raycaster.setFromCamera(pointer, camera);
    //    //intersects = raycaster.intersectObjects(objects, scene.children);
    //    intersects = raycaster.intersectObjects(scene.children);
    //    intersects.forEach(function (intersect) {
    //        if (intersect.object.name === "ground") {
    //            const rollOverPos = new THREE.Vector3().copy(intersect.point).divideScalar(2).floor().multiplyScalar(2).addScalar(1);
    //            rollOverMesh.position.set(rollOverPos.x, 0.011, rollOverPos.z);
    //        }
    //    });
    //});

    $(document).on('mousedown', function (e) {

        if (!isShiftDown) {
            const intersect = intersects[0];
            if (intersect.object.name.includes("box")) {

                scene.remove(intersect.object);

                objects.splice(objects.indexOf(intersect.object), 1);

            }

            animate;

            $(this).mousemove(function () {

                const intersect = intersects[0];
                if (intersect.object.name.includes("box")) {
                    scene.remove(intersect.object);

                    objects.splice(objects.indexOf(intersect.object), 1);

                }

                animate;
            });
        }
    }).mouseup(function () {
        $(this).unbind('mousemove');
    }).mouseout(function () {
        $(this).unbind('mousemove');
    });

}

function clearAll() {

    //console.log(scene.children.length);
    //if (objects.count > 0) {
    //    console.log("may laman");
    //    for (var i = scene.children.length - 1; i >= 0; i--) {
    //        const obj = scene.children[i];
    //        scene.remove(obj);
    //    }
    //}
    //else {
    //    console.log("walang laman");
    //}

}


function initDragWindow() {
    dragWindow($("#win-param"));
    dragWindow($("#win-rack"));
    dragWindow($("#win-props"));
}
function dragWindow(elmnt) {
    var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;

    if (elmnt.find(".win-header").length) {
        // if present, the header is where you move the DIV from:
        elmnt.find(".win-header").on("mousedown", dragMouseDown);
    } else {
        // otherwise, move the DIV from anywhere inside the DIV:
        elmnt.on("mousedown", dragMouseDown);
    }

    function dragMouseDown(e) {
        e = e || window.event;
        e.preventDefault();
        // get the mouse cursor position at startup:
        pos3 = e.clientX;
        pos4 = e.clientY;
        $(document).on("mouseup", closedragWindow);
        // call a function whenever the cursor moves:
        $(document).on("mousemove", elementDrag);
    }

    function elementDrag(e) {
        e = e || window.event;
        e.preventDefault();
        // calculate the new cursor position:
        pos1 = pos3 - e.clientX;
        pos2 = pos4 - e.clientY;
        pos3 = e.clientX;
        pos4 = e.clientY;
        // set the element's new position:
        elmnt.css("top", (elmnt.offset().top - pos2) + "px");
        elmnt.css("left", (elmnt.offset().left - pos1) + "px");
    }

    function closedragWindow() {
        // stop moving when mouse button is released:
        $(document).off("mouseup", closedragWindow);
        $(document).off("mousemove", elementDrag);
    }
}

function resetCamera() {
    const newOrientation = { xRot: - Math.PI / 2, yRot: 0, zRot: 0, xPos: 0, yPos: 125, zPos: 0 };
    const prevOrientation = {
        xRot: camera.rotation.x, yRot: camera.rotation.y, zRot: camera.rotation.z
        , xPos: camera.position.x, yPos: camera.position.y, zPos: camera.position.z
    };

    const tween = new TWEEN.Tween(prevOrientation).to(newOrientation, 1000).onUpdate(() => {
        camera.position.x = prevOrientation.xPos;
        camera.position.y = prevOrientation.yPos;
        camera.position.z = prevOrientation.zPos;

        camera.rotation.x = prevOrientation.xRot;
        camera.rotation.y = prevOrientation.yRot;
        camera.rotation.z = prevOrientation.zRot;

        controls.target.set(0, 0.5, 0);
    }).easing(TWEEN.Easing.Exponential.Out);

    tween.start();

}

function onDocumentKeyDown(event) {
    switch (event.keyCode) {
        case 16: isShiftDown = true; break;
        case 17: isCtrlDown = true; break;
    }
}

function onDocumentKeyUp(event) {
    switch (event.keyCode) {
        case 16: isShiftDown = false; break;
        case 17: isCtrlDown = false; break;
    }
}

// Light
function lights() {
    color = 0xFFFFFF;
    intensity = 10;
    light = new THREE.AmbientLight(color, intensity);
    //scene.add(light);
    group.add(light);
    light.name = "ambientLight";
}

function initSky() {

    // Add Sky
    sky = new Sky();
    sky.scale.setScalar(450000);
    //scene.add(sky);
    group.add(sky);

    sun = new THREE.Vector3();

    const effectController = {
        turbidity: 3.5,
        rayleigh: .85,
        mieCoefficient: 0,
        mieDirectionalG: .4,
        elevation: 52,
        azimuth: 180,
        exposure: renderer.toneMappingExposure
    };

    const uniforms = sky.material.uniforms;
    uniforms['turbidity'].value = effectController.turbidity;
    uniforms['rayleigh'].value = effectController.rayleigh;
    uniforms['mieCoefficient'].value = effectController.mieCoefficient;
    uniforms['mieDirectionalG'].value = effectController.mieDirectionalG;

    const phi = THREE.MathUtils.degToRad(90 - effectController.elevation);
    const theta = THREE.MathUtils.degToRad(effectController.azimuth);

    sun.setFromSphericalCoords(1, phi, theta);

    sky.name = "sky";

    uniforms['sunPosition'].value.copy(sun);

}


// Handle Resize
function onWindowResize() {
    camera.aspect = canvasWidth / canvasHeight;
    camera.updateProjectionMatrix();

    renderer.setSize(canvasWidth, canvasHeight);
}


function animate(t) {
    TWEEN.update(t);

    requestAnimationFrame(animate);


    // Call the appropriate tool function based on the current tool
    if (activeTool === 'default') {
        pointerTool();
    } else if (activeTool === 'draw') {
        drawTool3();
    } else if (activeTool === 'erase') {
        eraseTool();
    } else if (activeTool === 'clear') {
        clearAll();
    }



    renderer.render(scene, camera);

    stats.update();
}


init();

//initRaycaster();
animate();
