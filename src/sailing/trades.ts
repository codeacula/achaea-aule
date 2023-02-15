import ports from "./ports";
const trades = {
  circuitBreakerCounter: 0,
  circuitBreakerLimit: 0,
  findPort(name: string) {
    const allPorts = Object.values(ports);

    for (let index = 0; index < allPorts.length; index++) {
      const currentPort = allPorts[index];

      if (currentPort.name == name) {
        return currentPort;
      }
    }

    return null;
  },
  findRoutes(where: string, what: string, amount: 0) {
    const startPort = this.findPort(where);
  },
};

export default trades;
