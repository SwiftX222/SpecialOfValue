const isPremium = true; // จำลองระบบ Premium

if (!isPremium) {
  document.querySelectorAll("button")[0].innerText = "Locked";
}

window.api.onUpdateAvailable(() => {
  document.getElementById("updateNotice").classList.remove("hidden");
});