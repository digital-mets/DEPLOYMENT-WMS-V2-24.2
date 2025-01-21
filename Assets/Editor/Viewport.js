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

