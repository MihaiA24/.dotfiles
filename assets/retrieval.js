// Tiny reusable retrieval widget for lessons.
// Usage: any .quiz [data-answer] reveals its answer when a child button is clicked.
document.addEventListener("click", (event) => {
  const button = event.target.closest(".quiz button");
  if (!button) return;
  const quiz = button.closest(".quiz");
  const answer = quiz.querySelector(".answer");
  if (!answer) return;
  answer.classList.toggle("show");
  button.textContent = answer.classList.contains("show") ? "Hide answer" : "Reveal answer";
});
