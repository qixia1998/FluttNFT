import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("MarketplaceProductsModule", (m) => {
  const counter = m.contract("MarketplaceProducts");

  m.call(counter, "incBy", [5n]);

  return { counter };
});
