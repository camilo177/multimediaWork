import React, { useRef, useEffect, useState } from "react";
import { useLoader, useFrame } from "@react-three/fiber";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
import { TextureLoader, Sprite, SpriteMaterial, VideoTexture, Vector3 } from "three";

export default function ModeloPractica() {
  // ────────────── Carga de recursos y texturas ──────────────
  const modelo = useLoader(GLTFLoader, "/assets/model.glb");
  const texturaPrincipal = useLoader(TextureLoader, "/assets/baked.jpg");
  const texturaPantalla = useLoader(TextureLoader, "/assets/publicidad.jpg");
  const texturasNotas = [
    useLoader(TextureLoader, "/assets/note1.png"),
    useLoader(TextureLoader, "/assets/note2.png"),
    useLoader(TextureLoader, "/assets/note3.png"),
  ];

  // ────────────── Referencias de audio ──────────────
  const audioSilla = useRef(new Audio("/assets/chair-move.mp3")); // 🔹 Sonido de la silla
  const audioAmbiente = useRef(new Audio("/assets/ambiente.mp3"));  // 🔊 Sonido ambiente
  const audioPinguino = useRef(new Audio("/assets/pinguin.mp3")); // 🔹 Sonido del pingüino

  // ────────────── Configuración del video ──────────────
  const videoRef = useRef(document.createElement("video"));

  // ────────────── Referencias de objetos de la escena ──────────────
  const refSilla = useRef();
  const refAltavoz = useRef();
  const refNotas = useRef([]);
  const refPantalla = useRef();
  const refPlanta = useRef();
  const refPinguino = useRef();

  // ────────────── Estado para la posición de la silla ──────────────
  const [objetivoSilla, setObjetivoSilla] = useState(null);
  const [posicionInicialSilla, setPosicionInicialSilla] = useState(null);

  // ────────────── Referencia para el intervalo de notas ──────────────
  const intervaloNotasRef = useRef();

  // ────────────── Efecto de inicialización ──────────────
  useEffect(() => {
    if (!modelo) return;

    // Configurar la textura principal
    texturaPrincipal.flipY = false;
    audioAmbiente.current.loop = true;

    // Configurar el video y crear su textura
    videoRef.current.src = "/assets/video.mp4"; // Cambia esto por un video real
    videoRef.current.crossOrigin = "anonymous";
    videoRef.current.loop = true;
    videoRef.current.muted = true;
    videoRef.current.play(); // 🔹 Autoplay
    const texturaVideo = new VideoTexture(videoRef.current);

    // Recorrer la escena para asignar texturas según el nombre del objeto
    modelo.scene.traverse((objeto) => {
      if (objeto.isMesh) {
        objeto.material = objeto.material.clone();
        if (objeto.name === "desktop-plane-0") {
          objeto.material.map = texturaVideo;
          console.log("Se asignó video a:", objeto.name);
        } else if (objeto.name === "desktop-plane-1") {
          objeto.material.map = texturaPantalla;
        } else {
          objeto.material.map = texturaPrincipal;
        }
        objeto.material.needsUpdate = true;
        console.log("🔹 Objeto encontrado:", objeto.name);
      }
    });

    // Obtener las referencias de los objetos interactivos
    refSilla.current = modelo.scene.getObjectByName("chair");
    refPantalla.current = modelo.scene.getObjectByName("desktop-plane-1");
    refPlanta.current = modelo.scene.getObjectByName("plant");
    refPinguino.current = modelo.scene.getObjectByName("penguin");
    refAltavoz.current = modelo.scene.getObjectByName("speaker");

    // Guardar la posición inicial de la silla para poder restaurarla
    if (refSilla.current) {
      setPosicionInicialSilla(refSilla.current.position.clone());
    }

    // Actualizar la textura de la pantalla, si existe
    if (refPantalla.current) {
      refPantalla.current.material = refPantalla.current.material.clone();
      refPantalla.current.material.map = texturaPantalla;
      refPantalla.current.material.needsUpdate = true;
    }
  }, [modelo, texturaPantalla, texturaPrincipal]);

  // ────────────── Bucle de animación ──────────────
  useFrame(() => {
    // Movimiento suave de la silla hacia el objetivo
    if (refSilla.current && objetivoSilla) {
      refSilla.current.position.lerp(objetivoSilla, 0.1);
      if (refSilla.current.position.distanceTo(objetivoSilla) < 0.01) {
        setObjetivoSilla(null);
      }
    }

    // Animación de las notas musicales flotantes
    refNotas.current.forEach((nota, idx) => {
      nota.position.y += 0.02; // Elevar nota
      nota.material.opacity -= 0.005; // Desvanecer nota
      if (nota.material.opacity <= 0) {
        modelo.scene.remove(nota);
        refNotas.current.splice(idx, 1);
      }
    });
  });

  // ────────────── Funciones de audio y notas ──────────────
  const alClickAltavoz = () => {
    if (audioAmbiente.current.paused) {
      audioAmbiente.current.play();
      console.log("🎵 Sonido ambiental activado");
      iniciarNotas();
    } else {
      audioAmbiente.current.pause();
      console.log("🔇 Sonido ambiental pausado");
      detenerNotas();
    }
  };

  const iniciarNotas = () => {
    detenerNotas(); // Limpiar intervalos previos
    intervaloNotasRef.current = setInterval(() => {
      if (!refAltavoz.current) return;
      const texNota = texturasNotas[Math.floor(Math.random() * texturasNotas.length)];
      const materialNota = new SpriteMaterial({ map: texNota, transparent: true, opacity: 1 });
      const nota = new Sprite(materialNota);
      const posAltavoz = refAltavoz.current.position.clone();
      nota.position.set(posAltavoz.x, posAltavoz.y + 0.2, posAltavoz.z);
      nota.scale.set(0.3, 0.3, 0.3);
      modelo.scene.add(nota);
      refNotas.current.push(nota);
    }, 500);
  };

  const detenerNotas = () => {
    clearInterval(intervaloNotasRef.current);
  };

  // ────────────── Funciones de manejo de clics ──────────────
  const alClickSilla = () => {
    if (refSilla.current) {
      setObjetivoSilla(new Vector3(
        refSilla.current.position.x + 1.5,
        refSilla.current.position.y,
        refSilla.current.position.z
      ));
      // 🔊 Reproducir sonido al mover la silla
      audioSilla.current.play().catch((error) =>
        console.error("❌ Error al reproducir sonido de la silla:", error)
      );
    }
  };

  const alClickPlanta = () => {
    if (!refSilla.current || !posicionInicialSilla) return;
    console.log("🌿 Clic en planta: restaurando posición de la silla");
    setObjetivoSilla(posicionInicialSilla.clone());
  };

  const alClickPantalla = () => {
    if (videoRef.current.paused) {
      videoRef.current.play();
      console.log("▶️ Video en pantalla reproduciéndose");
    } else {
      videoRef.current.pause();
      console.log("⏸️ Video en pantalla pausado");
    }
  };

  const alClickPinguino = () => {
    audioPinguino.current.play().catch((error) =>
      console.error("❌ Error al reproducir sonido del pingüino:", error)
    );
  };

  const alClickObjeto = (evento) => {
    evento.stopPropagation();
    const nombreObjeto = evento.object.name;
    console.log(nombreObjeto);
    if (nombreObjeto === "chair") {
      alClickSilla();
      console.log("🌿 Clic en silla");
    } else if (nombreObjeto === "speaker") {
      alClickAltavoz();
      console.log("🌿 Clic en altavoz");
    } else if (nombreObjeto === "plant") {
      console.log("🌿 Clic en planta: restaurando silla");
      alClickPlanta();
    } else if (nombreObjeto === "desktop-plane-1") {
      console.log("🖥️ Clic en monitor 1");
    } else if (nombreObjeto === "desktop-plane-0") {
      console.log("🖥️ Clic en monitor (mause)");
      alClickPantalla();
    } else if (nombreObjeto === "penguin") {
      console.log("🐧 Clic en pingüino");
      alClickPinguino();
    }
  };

  // ────────────── Renderizado del componente ──────────────
  return (
    <primitive
      object={modelo.scene}
      scale={1}
      position={[0, -1, 0]}
      onPointerDown={alClickObjeto}
    />
  );
}
