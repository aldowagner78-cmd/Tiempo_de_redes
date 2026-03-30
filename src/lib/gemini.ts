import { GoogleGenAI } from "@google/genai";

const apiKey = process.env.GEMINI_API_KEY!;
const ai = new GoogleGenAI({ apiKey });

export const models = {
  flash: "gemini-3-flash-latest",
  pro: "gemini-3.1-pro-preview",
  lite: "gemini-3.1-flash-lite-preview",
  image: "gemini-3.1-flash-image-preview",
  live: "gemini-3.1-flash-live-preview",
};

export async function analyzeImage(base64Image: string, prompt: string) {
  const response = await ai.models.generateContent({
    model: models.pro,
    contents: [
      {
        parts: [
          { text: prompt },
          { inlineData: { data: base64Image, mimeType: "image/jpeg" } },
        ],
      },
    ],
  });
  return response.text;
}

export async function generateChatResponse(history: any[], message: string) {
  const chat = ai.chats.create({
    model: models.flash,
    config: {
      systemInstruction: "Eres NEXUS, una inteligencia artificial avanzada de control de comando. Tu tono es profesional, técnico y ligeramente futurista. Ayudas al comandante a gestionar misiones, analizar datos y optimizar el rendimiento de los sujetos NEX.",
    },
    history: history.map(h => ({
      role: h.role,
      parts: h.parts
    }))
  });
  
  const response = await chat.sendMessage({ message });
  return response.text;
}

export async function generateImageFromPrompt(prompt: string) {
  const response = await ai.models.generateContent({
    model: models.image,
    contents: { parts: [{ text: prompt }] },
    config: {
      imageConfig: {
        aspectRatio: "1:1",
        imageSize: "1K"
      }
    }
  });
  
  const parts = response.candidates?.[0]?.content?.parts;
  if (parts) {
    for (const part of parts) {
      if (part.inlineData) {
        return `data:image/png;base64,${part.inlineData.data}`;
      }
    }
  }
  return null;
}

export async function searchGrounding(query: string) {
  const response = await ai.models.generateContent({
    model: models.flash,
    contents: { parts: [{ text: query }] },
    config: {
      tools: [{ googleSearch: {} }],
    },
  });
  return {
    text: response.text,
    sources: response.candidates?.[0]?.groundingMetadata?.groundingChunks || []
  };
}

export async function mapsGrounding(query: string, location?: { lat: number, lng: number }) {
  const response = await ai.models.generateContent({
    model: models.flash,
    contents: { parts: [{ text: query }] },
    config: {
      tools: [{ googleMaps: {} }],
      toolConfig: {
        retrievalConfig: {
          latLng: location ? { latitude: location.lat, longitude: location.lng } : undefined
        }
      }
    },
  });
  return {
    text: response.text,
    sources: response.candidates?.[0]?.groundingMetadata?.groundingChunks || []
  };
}
