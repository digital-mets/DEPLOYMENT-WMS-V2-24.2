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
let planeDivision, rolloverPlaneSize;

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
let rackGeo, rackMaterial;



let activeObject = "Rack";
let wallVoxel;
let rackVoxel

let intersects;

let wallCount = 0;
let rackCount = 0;

let objUserData
let wallName = "";
let rackName = "";

let objArray = [];

let activeTool = "default";
let lastMesh

// For straight rollover
let initSizeVector = new THREE.Vector3();

// For saving and opening
const key = "sceneJSON";
let lsScene = localStorage.getItem(key);




const Objectgroup = new THREE.Group();
let objects = [];
const bufferGroup = new THREE.Group();
let arrBuffer = [];

const group = new THREE.Group();
// Vars for drawing direction of voxels
let startPos = new THREE.Vector3();
let endPos = new THREE.Vector3();
let drawing = false;
let dirVector = new THREE.Vector3();
let direction = "";


function init() {
    //console.log(lsScene);
    // Scene

    $("#btnConfirm").css('display', 'none')
    $("#btnCancel").css('display', 'none')
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0xedf1f5);
    //scene.fog = new THREE.FogExp2(0xefd1b5, 0.0025);

    // Get the height and width of the element
    canvasHeight = $("#main").height();
    canvasWidth = $("#main").width();

    // Camera
    camera = new THREE.PerspectiveCamera(35, canvasWidth / canvasHeight, 0.1, 1000);
    camera.position.set(0, 150, 0);

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
    floorMaterial = new THREE.MeshLambertMaterial({ color: "#8c8c8c" });
    floorMesh = new THREE.Mesh(floorGeometry, floorMaterial);
    floorMesh.position.set(0, -0.5, 0);
    floorMesh.rotation.set(Math.PI / -2, 0, 0);
    group.add(floorMesh);
    floorMesh.name = "floorMesh";

    // Ground Plane
    planeDivision = (planeHeight * planeWidth) / 2;
    rolloverPlaneSize = (planeHeight * planeWidth) / planeDivision;

    const geometry = new THREE.PlaneGeometry(planeHeight, planeWidth);
    geometry.rotateX(- Math.PI / 2);
    plane = new THREE.Mesh(geometry, new THREE.MeshBasicMaterial({ color: "#ffffff" }));
    plane.position.set(0, -0.01, 0);
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
    //cubeGeo = new THREE.PlaneGeometry(rolloverPlaneSize, rolloverPlaneSize);
    cubeGeo = new THREE.BoxGeometry(rolloverPlaneSize, rolloverPlaneSize, rolloverPlaneSize);
    cubeGeo.rotateX(- Math.PI / 2);
    cubeMaterial = new THREE.MeshLambertMaterial({ color: "#00ff00", opacity: 0.8, transparent: true });
    // Rack Cube 
    rackGeo = new THREE.BoxGeometry(rolloverPlaneSize, rolloverPlaneSize, rolloverPlaneSize);
    rackGeo.rotateX(- Math.PI / 2);
    rackMaterial = new THREE.MeshLambertMaterial({ color: "#0000ff", opacity: 0.8, transparent: true });
    // Rollover
    const rollOverGeo = new THREE.PlaneGeometry(rolloverPlaneSize, rolloverPlaneSize);
    rollOverMaterial = new THREE.MeshPhongMaterial({ color: "#00ff00", opacity: 0.8, transparent: true });
    rollOverMesh = new THREE.Mesh(rollOverGeo, rollOverMaterial);
    rollOverMesh.position.set(rolloverPlaneSize / 2, 0.11, -rolloverPlaneSize / 2)
    rollOverMesh.rotateX(- Math.PI / 2);
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

    $("#wall-tool").click(function () {
        setActiveTool('wall');
    });

    $("#rack-tool").click(function () {
        setActiveTool('rack');
    });

    $("#erase-tool").click(function () {
        setActiveTool('erase');
    });

    $("#btnConfirm").click(function () {
        setActiveTool('confirm')
    })

    $("#btnCancel").click(function () {
        setActiveTool('cancel')
    })

    $(function () {
        $('[data-toggle="tooltip"]').tooltip({ boundary: 'window', trigger: "hover" })
    });

    //$(".ui-elem").hover(
    //    function () {
    //        setActiveTool("default");
    //    },
    //    function () {
    //        setActiveTool(activeTool);
    //    }
    //);

    // Add group to scene
    scene.add(group);

    group.name = "sceneInit"
    //scene.add(bufferGroup);
    scene.add(Objectgroup)
    //console.log(group.children);
    group.add(bufferGroup)
    window.onbeforeunload = function () {
        return "Data will be lost if you leave the page, are you sure?";
    };

    document.addEventListener('keydown', e => {

        const ctrl = e.ctrlKey;
        const shift = e.shiftKey;
        const key = e.key.toUpperCase();

        if (ctrl && !shift) {
            switch (key) {
                case 'S': // Save scene
                    e.preventDefault()
                    exportJSON();
                    break;
                case 'O': // Open Scene
                    e.preventDefault();
                    break;
                default:
                    e.preventDefault();
                    console.log("CTRL + " + key);
                    break
            }
        }

        if (!ctrl && shift) {
            switch (key) {
                case 'D': // Draw tool
                    e.preventDefault();
                    setActiveTool('draw');
                    break
                case 'E': // Erase tool
                    e.preventDefault();
                    setActiveTool('erase');
                    break
                case 'R': // Reset Camera
                    e.preventDefault();
                    resetCamera();
                    break
                default:
                    console.log("SHIFT + " + key);
                    break
            }
        }

        if (ctrl && shift) {
            switch (key) {
                case 'R': // Camera reset
                    e.preventDefault();
                    resetCamera();
                    break
                default:
                    e.preventDefault();
                    console.log("CTRL + SHIFT + " + key);
                    break
            }
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
    gridObject.position.y += -0.011;
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
        intersects = raycaster.intersectObjects(scene.children);
        intersects.forEach(function (intersect) {
            //console.log(intersect.object.name);
            if (intersect.object.name === "ground") {
                const rollOverPos = new THREE.Vector3().copy(intersect.point).divideScalar(2).floor().multiplyScalar(2).addScalar(1);

                if (drawing) {
                    if (startPos.x != 0 && startPos.y != 0 && startPos.z != 0) {
                        // lock axis
                        let curvalX = startPos.x - rollOverPos.x;
                        let curvalZ = startPos.z - rollOverPos.z;

                        if (Math.abs(curvalX) > Math.abs(curvalZ)) {
                            direction = "horizontal";
                            rollOverMesh.position.set(rollOverPos.x, 0.011, startPos.z);
                        } else {
                            direction = "vertical";
                            rollOverMesh.position.set(startPos.x, 0.011, rollOverPos.z);
                        }

                    }
                    else {
                        rollOverMesh.position.set(rollOverPos.x, 0.011, rollOverPos.z);
                    }
                }
                else {
                    //const rollOverPos = new THREE.Vector3().copy(intersect.point).divideScalar(2).floor().multiplyScalar(2).addScalar(1);
                    rollOverMesh.position.set(rollOverPos.x, 0.011, rollOverPos.z);
                }
            }
        });
    });
}

function updateData(type, name) {
    $("#inputType").val(type)
    $("#txtName").val(name)
}

function pointerTool() {
    $('canvas').css('cursor', 'default');
    rollOverMesh.visible = false;

    controls.enablePan = true;
}

function wallTool() {
    $('canvas').css('cursor', 'crosshair');
    $("#btnConfirm").css('display', 'block');
    $("#btnCancel").css('display', 'block');

    rollOverMesh.visible = true;
    rollOverMesh.material.color.setHex(0x57f781);
    controls.enablePan = false;

    $(document).on("mousedown", function (e) {
        if (!isShiftDown) {
            if (intersects.length > 0) {
                const objExist = objects.find(function (object) {
                    return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                });
                if (!objExist) {
                    intersects.forEach(function (intersect) {
                        if (intersect.object.name === "ground") {
                            drawing = true;

                            if (startPos.x != 0 && startPos.y != 0 && startPos.z != 0) {
                                var lastMesh = scene.getObjectByName(wallName, true);
                                if (direction == "horizontal") {
                                    if ((startPos.x - rollOverMesh.position.x) / 2 > 0) {
                                        lastMesh.position.x = (startPos.x - (1 + (startPos.x - rollOverMesh.position.x) / 2)) + 1;
                                        lastMesh.scale.x = (startPos.x - rollOverMesh.position.x) / 2 + 1;
                                    } else {
                                        lastMesh.position.x = (startPos.x - (1 + (startPos.x - rollOverMesh.position.x) / 2));
                                        lastMesh.scale.x = ((startPos.x - rollOverMesh.position.x) / 2);
                                    }
                                } else {
                                    if ((startPos.z - rollOverMesh.position.z) / 2 > 0) {
                                        lastMesh.position.z = (startPos.z - (1 + (startPos.z - rollOverMesh.position.z) / 2)) + 1;
                                        lastMesh.scale.z = (startPos.z - rollOverMesh.position.z) / 2 + 1;
                                    } else {
                                        lastMesh.position.z = (startPos.z - (1 + (startPos.z - rollOverMesh.position.z) / 2));
                                        lastMesh.scale.z = (startPos.z - rollOverMesh.position.z) / 2;
                                    }
                                }

                                startPos = { x: 0, y: 0, z: 0 };

                            } else {

                                startPos = { x: rollOverMesh.position.x, y: 1, z: rollOverMesh.position.z };

                                wallVoxel = new THREE.Mesh(cubeGeo, cubeMaterial);
                                //voxel.position.copy(rollOverMesh.position);

                                wallVoxel.position.set(rollOverMesh.position.x, 1, rollOverMesh.position.z);

                                //scene.add(voxel);

                                objects.push(wallVoxel);

                                bufferGroup.add(wallVoxel);
                                let wallType = "wall"

                                wallName = "grp1.wall" + wallCount;
                                //voxel.userData = {name: lastObj, type: "default"};
                                wallVoxel.userData.name = wallName;
                                wallVoxel.userData.type = wallType;
                                wallVoxel.name = wallName;
                                wallVoxel.type = wallType
                                wallCount = wallCount + 1;
                                updateData(wallVoxel.userData.type, wallVoxel.userData.name)
                            }
                        }
                    });
                }
            }

            //const cubeGeo = new THREE.BoxGeometry(rolloverPlaneSize, rolloverPlaneSize, rolloverPlaneSize);
            //const cubeMaterial = new THREE.MeshLambertMaterial({
            //    color: 0x00ff00, transparent: true,
            //    opacity: 0.2
            //});

            //const cubeMesh = new THREE.Mesh(cubeGeo, cubeMaterial);


            //cubeMesh.position.copy({ x: rollOverMesh.position.x, y: 1.01, z: rollOverMesh.position.z });

            //scene.add(cubeMesh);
        }
    });
}

let rackBuffer = [];

function rackTool() {
    $('canvas').css('cursor', 'crosshair');
    $("#btnConfirm").css('display', 'block');
    $("#btnCancel").css('display', 'block');

    rollOverMesh.visible = true;
    //rollOverMesh.material.color.setHex(0x34cfeb);
    rollOverMesh.material.color.setHex(0xff0000)
    controls.enablePan = false;

    $(document).on("mousedown", function (e) {
        if (!isShiftDown) {
            if (intersects.length > 0) {
                const objExist = objects.find(function (object) {
                    return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                });
                if (!objExist) {
                    intersects.forEach(function (intersect) {
                        if (intersect.object.name === "ground") {
                            drawing = true;
                            var lastMesh = scene.getObjectByName(rackName, true);
                            rackVoxel = new THREE.Mesh(rackGeo, rackMaterial);
                            let rackType = "Rack";
                            //console.log(rackBuffer);
                            //console.log(bufferGroup.children);
                            if (drawing) {
                                if (rackBuffer.length == 0) {
                                    startPos = { x: rollOverMesh.position.x, y: 1, z: rollOverMesh.position.z };
                                    //voxel.position.copy(rollOverMesh.position);

                                    rackVoxel.position.set(rollOverMesh.position.x, 1, rollOverMesh.position.z);

                                    //scene.add(voxel);

                                    objects.push(rackVoxel);
                                    rackBuffer.push(rackVoxel);

                                    bufferGroup.add(rackVoxel);
                                    let rackType = "Rack";

                                    rackName = "grp1.rack" + rackCount;
                                    //voxel.userData = {name: lastObj, type: "default"};
                                    rackVoxel.userData.name = rackName;
                                    rackVoxel.userData.type = rackType;
                                    rackVoxel.name = rackName;
                                    //rackVoxel.type = rackType;
                                    rackCount = rackCount + 1;
                                    updateData(rackVoxel.userData.type, rackVoxel.userData.name)
                                } else if (rackBuffer.length == 1) {
                                    startPos = { x: rollOverMesh.position.x, y: 1, z: rollOverMesh.position.z };

                                    rackVoxel.position.set(rollOverMesh.position.x, 1, rollOverMesh.position.z);

                                    objects.push(rackVoxel);
                                    rackBuffer.push(rackVoxel);

                                    bufferGroup.add(rackVoxel);
                                    let rackType = "Rack";

                                    rackName = "grp1.rack" + rackCount;
                                    //voxel.userData = {name: lastObj, type: "default"};
                                    rackVoxel.userData.name = rackName;
                                    rackVoxel.userData.type = rackType;
                                    rackVoxel.name = rackName;
                                    //rackVoxel.type = rackType;
                                    rackCount = rackCount + 1;
                                    updateData(rackVoxel.userData.type, rackVoxel.userData.name)
                                } else if (rackBuffer.length == 2) {
                                    startPos = { x: rollOverMesh.position.x, y: 1, z: rollOverMesh.position.z };

                                    rackVoxel.position.set(rollOverMesh.position.x, 1, rollOverMesh.position.z);

                                    objects.push(rackVoxel);
                                    rackBuffer.push(rackVoxel);

                                    bufferGroup.add(rackVoxel);
                                    let rackType = "Rack";

                                    rackName = "grp1.rack" + rackCount;
                                    //voxel.userData = {name: lastObj, type: "default"};
                                    rackVoxel.userData.name = rackName;
                                    rackVoxel.userData.type = rackType;
                                    rackVoxel.name = rackName;
                                    //rackVoxel.type = rackType;
                                    rackCount = rackCount + 1;
                                    updateData(rackVoxel.userData.type, rackVoxel.userData.name)

                                    drawRack();
                                }

                            }
                        }
                    });
                }
            }
        }
    }).mouseout(function () {
        btnConfirm()
    })
}

function drawRack() {
    let sPos = rackBuffer[0].position;
    let P1 = rackBuffer[1].position;
    let P2 = rackBuffer[2].position;

    let rackLength = new THREE.Vector3;
    let rackWidth = new THREE.Vector3;

    rackLength.x = sPos.x - P1.x;
    rackLength.y = sPos.y - P1.y;
    rackLength.z = sPos.z - P1.z;

    rackWidth.x = P1.x - P2.x;
    rackWidth.y = P1.y - P2.y;
    rackWidth.z = P1.z - P2.z;

    //Horizontal Start
    if (rackLength.x < 0 && rackWidth.z < 0) {
        rackVoxel.position.set(sPos.x - (rackLength.x / 2), 1, sPos.z - (rackWidth.z / 2));
        rackVoxel.scale.set((rackLength.x / 2) - 1, 1, (rackWidth.z / 2) - 1);
    }
    else if (rackLength.x < 0 && rackWidth.z > 0) {
        rackVoxel.position.set(sPos.x - (rackLength.x / 2), 1, sPos.z - (rackWidth.z / 2));
        rackVoxel.scale.set((rackLength.x / 2) - 1, 1, (rackWidth.z / 2) + 1);
    }
    else if (rackLength.x > 0 && rackWidth.z < 0) {
        rackVoxel.position.set(sPos.x - (rackLength.x / 2), 1, sPos.z - (rackWidth.z / 2));
        rackVoxel.scale.set((rackLength.x / 2) + 1, 1, (rackWidth.z / 2) - 1);
    }
    else if (rackLength.x > 0 && rackWidth.z > 0) {
        rackVoxel.position.set(sPos.x - (rackLength.x / 2), 1, sPos.z - (rackWidth.z / 2));
        rackVoxel.scale.set((rackLength.x / 2) + 1, 1, (rackWidth.z / 2) + 1);
    }

    //Vertical Start
    else if (rackLength.z < 0 && rackWidth.x < 0) {
        rackVoxel.position.set(sPos.x - (rackWidth.x / 2), 1, sPos.z - (rackLength.z / 2));
        rackVoxel.scale.set((rackWidth.x / 2) - 1, 1, (rackLength.z / 2) - 1);
    }
    else if (rackLength.z < 0 && rackWidth.x > 0) {
        rackVoxel.position.set(sPos.x - (rackWidth.x / 2), 1, sPos.z - (rackLength.z / 2));
        rackVoxel.scale.set((rackWidth.x / 2) + 1, 1, (rackLength.z / 2) - 1);
    }
    else if (rackLength.z > 0 && rackWidth.x < 0) {
        rackVoxel.position.set(sPos.x - (rackWidth.x / 2), 1, sPos.z - (rackLength.z / 2));
        rackVoxel.scale.set((rackWidth.x / 2) - 1, 1, (rackLength.z / 2) + 1);
    }
    else if (rackLength.z > 0 && rackWidth.x > 0) {
        rackVoxel.position.set(sPos.x - (rackWidth.x / 2), 1, sPos.z - (rackLength.z / 2));
        rackVoxel.scale.set((rackWidth.x / 2) + 1, 1, (rackLength.z / 2) + 1);
    }
    else {
        console.log("cancel");
    }
    
    objects.push(rackVoxel);
    let rackType = "Rack";

    rackName = "grp1.rack" + rackCount;
    //voxel.userData = {name: lastObj, type: "default"};
    rackVoxel.userData.name = rackName;
    rackVoxel.userData.type = rackType;
    rackVoxel.name = rackName;
    //rackVoxel.type = rackType;
    rackCount = rackCount + 1;
    updateData(rackVoxel.userData.type, rackVoxel.userData.name)
    
}


function mouseOut() {
    startPos = { x: 0, y: 0, z: 0 }
    endPos = { x: 0, y: 0, z: 0 }
    rollOverMesh.position.set(0, 0, 0)
    object.position.set(0, 0, 0)
    drawing = false
    direction = "";
}

function btnConfirm() {
    /*for(let i = 0; i < bufferGroup.children.length; i++){
        objUserData = bufferGroup.children[i];
        if(objUserData.userData.type == "wall"){
            arrBuffer.push(bufferGroup)
            bufferGroup.name = "Buffer Group";
            rollOverMesh.visible = false
            drawing = false
            Objectgroup.add(bufferGroup)
            startPos = { x: 0, y: 0, z: 0 }
            endPos = { x: 0, y: 0, z: 0 }
            console.log(Objectgroup)
            rackCount = 0;
            //updateData(objUserData.name)
        } else {
            drawing = false
            startPos = { x: 0, y: 0, z: 0 }
            endPos = { x: 0, y: 0, z: 0 }
            alert("You can't store data here!")
            console.log(Objectgroup)
        }
    }*/
    arrBuffer.push(bufferGroup)
    bufferGroup.name = "Buffer Group";
    rollOverMesh.visible = false
    drawing = false
    Objectgroup.add(bufferGroup)
    startPos = { x: 0, y: 0, z: 0 }
    endPos = { x: 0, y: 0, z: 0 }
    //console.log(Objectgroup)
}

function btnCancel() {
    /*for (var i = Objectgroup.children.length - 1; i >= 0; i--){
      Objectgroup.remove(Objectgroup.children[i--])
    
     }*/
    /*objects.forEach(function(v, i){
        v.material.dispose();
        v.geometry.dispose();
        Objectgroup.remove(v)
        console.log(v)
    })*/

    let text = "Are you sure to cancel changes?";
    if (confirm(text) == true) {
        drawing = false
        startPos = { x: 0, y: 0, z: 0 }
        endPos = { x: 0, y: 0, z: 0 }
        bufferGroup.clear()
        objects.pop()
        rackCount = 0;
        wallCount = 0;
    } else {
        drawing = false
        startPos = { x: 0, y: 0, z: 0 }
        endPos = { x: 0, y: 0, z: 0 }
    }


}
let btnClear = document.getElementById('btnClearAll')
btnClear.addEventListener('click', function () {
    btnClearAll()
})

function btnClearAll() {
    console.log('clear')

    objects = [];
    count = 0;

    startPos = { x: 0, y: 0, z: 0 }
    endPos = { x: 0, y: 0, z: 0 }
    console.log(Objectgroup)
}

// Straight line rollovers
//let drawing = false;

function endDraw() {
    $(document).unbind('mousemove');

    //if (drawing) {
    //    drawMesh();   
    //}
    console.log(startPos);
    console.log(endPos);
    let sPos = new THREE.Vector3(startPos.x, startPos.y, startPos.z);
    let ePos = new THREE.Vector3(endPos.x, endPos.y, endPos.z);

    let distance = sPos.distanceTo(ePos);

    console.log(distance);


    direction = "";
    drawing = false;
    startPos = { x: 0, y: 0, z: 0 }
    endPos = { x: 0, y: 0, z: 0 };
    //bufferGroup.clear();
    objects = [];
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
            if (intersect.object.name.includes("grp1")) {

                bufferGroup.remove(intersect.object);

                objects.splice(objects.indexOf(intersect.object), 1);

            }

            animate;

            $(this).mousemove(function () {

                const intersect = intersects[0];
                if (intersect.object.name.includes("box")) {
                    bufferGroup.remove(intersect.object);

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
    //bufferGroup.clear()

    startPos = { x: 0, y: 0, z: 0 }
    endPos = { x: 0, y: 0, z: 0 }
}


//File Management
function download(content, fileName, contentType) {
    var a = document.createElement("a");
    var file = new Blob([content], { type: contentType });
    a.href = URL.createObjectURL(file);
    a.download = fileName;
    a.click();
}

function exportJSON() {
    scene.updateMatrixWorld();
    var result = scene.toJSON();
    var output = JSON.stringify(result);

    localStorage.setItem("sceneJSON", output);

    console.log(output);
    //download(output, 'scene.json', 'application/json');

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
    const newOrientation = { xRot: - Math.PI / 2, yRot: 0, zRot: 0, xPos: 0, yPos: 150, zPos: 0 };
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
    camera.aspect = $("#main").width() / $("#main").height();
    camera.updateProjectionMatrix();

    renderer.setSize($("#main").width(), $("#main").height());


    //camera.aspect = canvasWidth / canvasHeight;
    //camera.updateProjectionMatrix();

    //renderer.setSize(canvasWidth, canvasHeight);
}


function animate(t) {
    TWEEN.update(t);



    //console.log(camera.position);
    // Call the appropriate tool function based on the current tool
    switch (activeTool) {
        case "default":
            pointerTool();
            break;
        case "wall":
            wallTool();
            break;
        case "rack":
            rackTool();
            break;
        case "erase":
            eraseTool();
            break;
        case "confirm":
            btnConfirm();
            break;
        case "cancel":
            btnCancel();
            break;
        default:
            break;
    }



    //if (activeTool === 'default') {
    //    pointerTool();
    //} else if (activeTool === 'draw') {
    //    drawTool4();
    //} else if (activeTool === 'erase') {
    //    eraseTool();
    //} else if (activeTool === 'clear') {
    //    clearAll();
    //}

    requestAnimationFrame(animate);

    renderer.render(scene, camera);

    stats.update();
}

init();

//if (!lsScene) {
//    init();
//} else {
//    scene = new THREE.Scene();

//    let loader = new THREE.ObjectLoader();
//    //console.log(lsScene);
//    let sceneJSON = JSON.parse(lsScene);

//    //let sceneObject = loader.parse(sceneJSON);
//    loader.parse(sceneJSON, function (result) {
//        if (result.isScene) {

//            scene.execute(new SetSceneCommand(scene, result));

//        } else {

//            scene.execute(new AddObjectCommand(scene, result));

//        }
//        //scene.execute(new AddObjectCommand(scene, result));
//    });

//    //scene.execute(new SetSceneCommand(scene, sceneObject));

//    //scene.add(sceneObject);
//}


//initraycaster();
animate();
