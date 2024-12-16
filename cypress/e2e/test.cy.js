describe("The Home Page", () => {
  it("successfully loads", () => {
    cy.visit("/test");
  });

	it("link works", () => {
    cy.visit("/test");
    cy.get("a").click();
    cy.url().should("include", "/");
  });
});
