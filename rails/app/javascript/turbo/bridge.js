export default class Bridge {
  static register(token) {
    fetch("/notification_tokens", {
      body: JSON.stringify({ token: token }),
      method: "POST",
      headers: { "Content-Type": "application/json" },
    });
  }
}