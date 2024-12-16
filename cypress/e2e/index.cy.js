describe("The Home Page", () => {
  it("successfully loads", () => {
    cy.visit("/");
  });

  it("link works", () => {
    cy.visit("/");
    cy.get("a").click();
    cy.url().should("include", "/test");
  });
});
