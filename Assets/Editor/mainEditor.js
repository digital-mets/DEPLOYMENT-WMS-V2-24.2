import * as THREE from 'three';
import * as TWEEN from '@tweenjs/tween.js';
import { MapControls } from 'OrbitControls';
import { Sky } from 'Sky';
import Stats from 'Stats';



let scene, camera, renderer, controls, stats;
let light, color, intensity;
let sky, sun;

//let planeHeight, planeWidth;
let planeSize = 60, planeDivision, rolloverPlaneSize, objSize;

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

let intersects, intersect;

let count = 0;

let objects = [];



let activeControl = "pointer";
//let yHeight = 0;



function init() {
    // Scene
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0xedf1f5);
    ///scene.fog = new THREE.FogExp2(0xefd1b5, 0.0025);

    let element = document.getElementById('main');

    // Get the height and width of the element
    canvasHeight = element.clientHeight;
    canvasWidth = element.clientWidth;

    // Camera
    camera = new THREE.PerspectiveCamera(75, canvasWidth / canvasHeight, 0.1, 1000);
    camera.position.set(0, 48, 0);

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
    controls.maxDistance = 100;
    controls.enablePan = false;
    //controls.mouseButtons = { ORBIT: THREE.MOUSE.RIGHT, ZOOM: THREE.MOUSE.MIDDLE, PAN: THREE.MOUSE.LEFT};

    // Floor
    floorGeometry = new THREE.PlaneGeometry(10000, 10000)
    floorMaterial = new THREE.MeshLambertMaterial({
        color: "#8c8c8c"
    })
    floorMesh = new THREE.Mesh(floorGeometry, floorMaterial)
    floorMesh.position.set(0, -0.1, 0)
    floorMesh.rotation.set(Math.PI / -2, 0, 0)
    scene.add(floorMesh)
    floorMesh.name = "floorMesh";

    planeDivision = planeSize / 2;
    rolloverPlaneSize = planeSize / planeDivision;

    // ground Plane
    const geometry = new THREE.PlaneGeometry(planeSize, planeSize);
    geometry.rotateX(- Math.PI / 2);
    //plane = new THREE.Mesh(geometry, new THREE.MeshBasicMaterial({ visible: false }));
    plane = new THREE.Mesh(geometry, new THREE.MeshBasicMaterial({ color: "#ffffff" }));
    plane.position.set(0, 0, 0)
    scene.add(plane);
    plane.name = "ground";


    cubeGeo = new THREE.BoxGeometry(rolloverPlaneSize, rolloverPlaneSize, rolloverPlaneSize);
    cubeMaterial = new THREE.MeshLambertMaterial({ color: 0x00ff00 });

    const rollOverGeo = new THREE.PlaneGeometry(rolloverPlaneSize, rolloverPlaneSize);
    rollOverMaterial = new THREE.MeshBasicMaterial({ color: 0x57f781, opacity: 0.5, transparent: true });
    rollOverMesh = new THREE.Mesh(rollOverGeo, rollOverMaterial);
    rollOverMesh.position.set(rolloverPlaneSize / 2, 0.11, -rolloverPlaneSize / 2)
    rollOverMesh.rotateX(- Math.PI / 2);
    scene.add(rollOverMesh);

    //const rollOverGeo = new THREE.BoxGeometry(2, 2, 2);
    //rollOverMaterial = new THREE.MeshBasicMaterial({ color: 0xff0000, opacity: 0.5, transparent: true });
    //rollOverMesh = new THREE.Mesh(rollOverGeo, rollOverMaterial);
    //rollOverMesh.position.set(1, 0.1, -1)
    //scene.add(rollOverMesh);

    // Sky
    initSky();

    // Lights
    lights();

    //planeDivision = planeSize / 2;

    // Grid Helper
    //const size = 40;
    //const divisions = 20;

    //const gridHelper = new THREE.GridHelper(size, divisions);
    //scene.add(gridHelper);
    //gridHelper.position.set(0, .01, 0);
    ////objects.push(gridHelper);

    const grid = new THREE.GridHelper(planeSize, planeDivision, 0x000000, 0x000000);
    grid.material.opacity = 0.2;
    grid.material.transparent = true;
    //grid.position.set(0, 0.01, 0);
    grid.position.y += 0.01;
    scene.add(grid);
    grid.name = "gridhelper";
    

    // Stats
    stats = new Stats();

    let thisParent = document.getElementById("stats");
    thisParent.appendChild(stats.dom);

    let childElement = document.querySelector('#stats div');
    childElement.style.position = 'relative';


    // Events
    draw();

    document.addEventListener('keydown', onDocumentKeyDown);
    document.addEventListener('keyup', onDocumentKeyUp);

    window.addEventListener('resize', onWindowResize, false);

    $("#btnReset").click(function () {
        resetCamera();
    });

    $(function () {
        $('[data-toggle="tooltip"]').tooltip({ boundary: 'window', trigger: "hover" })
    })
}

function draw(objType) {
    $(document).on('mousedown', function (e) {
        if (!isShiftDown) {
            if (intersects.length > 0) {

                if (isCtrlDown) {
                    const intersect = intersects[0];
                    //if (intersect.object.name !== "ground" ) {
                    if (intersect.object.name.includes("box")) {

                        scene.remove(intersect.object);

                        objects.splice(objects.indexOf(intersect.object), 1);

                    }

                } else {
                    const objExist = objects.find(function (object) {
                        return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                    });
                    if (!objExist) {
                        intersects.forEach(function (intersect) {
                            if (intersect.object.name === "ground") {
                                const voxel = new THREE.Mesh(cubeGeo, cubeMaterial);
                                //voxel.position.copy(rollOverMesh.position);

                                voxel.position.set(rollOverMesh.position.x, 1, rollOverMesh.position.z)

                                scene.add(voxel);

                                objects.push(voxel);
                                voxel.name = "box" + count;

                                count = count + 1;
                            }
                        });
                    }
                }

                //const objExist = objects.find(function (object) {
                //    return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                //});
                //if (!objExist) {
                //    intersects.forEach(function (intersect) {
                //        if (intersect.object.name === "ground") {
                //            const voxel = new THREE.Mesh(cubeGeo, cubeMaterial);
                //            //voxel.position.copy(rollOverMesh.position);

                //            voxel.position.set(rollOverMesh.position.x, 1, rollOverMesh.position.z)

                //            scene.add(voxel);

                //            objects.push(voxel);
                //        }
                //    });
                //}
            }

            animate;

            $(this).mousemove(function () {

                if (isCtrlDown) {
                    const intersect = intersects[0];
                    //if (intersect.object.name !== "ground" ) {
                    if (intersect.object.name.includes("box")) {

                        scene.remove(intersect.object);

                        objects.splice(objects.indexOf(intersect.object), 1);

                    }

                } else {
                    const objExist = objects.find(function (object) {
                        return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                    });
                    if (!objExist) {
                        intersects.forEach(function (intersect) {
                            if (intersect.object.name === "ground") {
                                const voxel = new THREE.Mesh(cubeGeo, cubeMaterial);
                                //voxel.position.copy(rollOverMesh.position);

                                voxel.position.set(rollOverMesh.position.x, 1, rollOverMesh.position.z)

                                scene.add(voxel);

                                objects.push(voxel);
                                voxel.name = "box" + count;

                                count = count + 1;
                            }
                        });
                    }
                }
                //if (intersects.length > 0) {
                //    const objExist = objects.find(function (object) {
                //        return (object.position.x === rollOverMesh.position.x) && (object.position.z === rollOverMesh.position.z);
                //    });
                //    if (!objExist) {
                //        intersects.forEach(function (intersect) {
                //            if (intersect.object.name === "ground") {
                //                const voxel = new THREE.Mesh(cubeGeo, cubeMaterial);
                //                //voxel.position.copy(rollOverMesh.position);

                //                voxel.position.set(rollOverMesh.position.x, 1, rollOverMesh.position.z)

                //                scene.add(voxel);

                //                objects.push(voxel);
                //            }
                //        });
                //    }
                //}

                animate;
            });
        }
    }).mouseup(function () {
        $(this).unbind('mousemove');
    }).mouseout(function () {
        $(this).unbind('mousemove');
    });

    // Pointer Move
    $(document).on('pointermove', function (event) {
        pointer.x = (event.clientX / canvasWidth) * 2 - 1;
        pointer.y = - (event.clientY / canvasHeight) * 2 + 1;

        raycaster.setFromCamera(pointer, camera);
        //intersects = raycaster.intersectObjects(objects, scene.children);
        intersects = raycaster.intersectObjects(scene.children);
        intersects.forEach(function (intersect) {
            if (intersect.object.name === "ground") {
                const rollOverPos = new THREE.Vector3().copy(intersect.point).divideScalar(2).floor().multiplyScalar(2).addScalar(1);
                rollOverMesh.position.set(rollOverPos.x, 0.011, rollOverPos.z);
            }
        });
    });
}

function resetCamera(orientation) {
    //camera.position.set(0, 48, 0);
    //camera.rotation.set(- Math.PI / 2, 0, 0);

    const newOrientation = { xRot: - Math.PI / 2, yRot: 0, zRot: 0, xPos: 0, yPos: 48, zPos: 0 };
    const prevOrientation = {
        xRot: camera.rotation.x, yRot: camera.rotation.y, zRot: camera.rotation.z
        , xPos: camera.position.x, yPos: camera.position.y, zPos: camera.position.z
    };

    const tween = new TWEEN.Tween(prevOrientation).to(newOrientation, 1000).onUpdate(() => {
        //camera.position.set(0, 48, 0);
        camera.position.x = prevOrientation.xPos;
        camera.position.y = prevOrientation.yPos;
        camera.position.z = prevOrientation.zPos;

        camera.rotation.x = prevOrientation.xRot;
        camera.rotation.y = prevOrientation.yRot;
        camera.rotation.z = prevOrientation.zRot;
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
    scene.add(light);
}

function initSky() {

    // Add Sky
    sky = new Sky();
    sky.scale.setScalar(450000);
    scene.add(sky);

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
    renderer.render(scene, camera);

    stats.update();
}

init();
animate();
