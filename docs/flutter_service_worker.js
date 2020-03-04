'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/assets\FontManifest.json": "580ff1a5d08679ded8fcf5c6848cece7",
  "/assets\fonts\MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
  "/assets\LICENSE": "5f38f034877768db01716c6a449bce39",
  "/index.html": "7b81680a25ff1f85ac553d594284b32a",
  "/main.dart.js": "c8fcbc422231f0725a18b0149292b264"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request, {
          credentials: 'include'
        });
      })
  );
});
