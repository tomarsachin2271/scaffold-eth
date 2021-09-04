import { Button } from "antd";
import React, { useEffect } from "react";
import { useThemeSwitcher } from "react-css-theme-switcher";
import Address from "./Address";
import Balance from "./Balance";
import Switch from '@material-ui/core/Switch';
import Wallet from "./Wallet";

/*
  ~ What it does? ~

  Displays an Address, Balance, and Wallet as one Account component,
  also allows users to log in to existing accounts and log out

  ~ How can I use? ~

  <Account
    address={address}
    localProvider={localProvider}
    userProvider={userProvider}
    mainnetProvider={mainnetProvider}
    price={price}
    web3Modal={web3Modal}
    loadWeb3Modal={loadWeb3Modal}
    logoutOfWeb3Modal={logoutOfWeb3Modal}
    blockExplorer={blockExplorer}
  />

  ~ Features ~

  - Provide address={address} and get balance corresponding to the given address
  - Provide localProvider={localProvider} to access balance on local network
  - Provide userProvider={userProvider} to display a wallet
  - Provide mainnetProvider={mainnetProvider} and your address will be replaced by ENS name
              (ex. "0xa870" => "user.eth")
  - Provide price={price} of ether and get your balance converted to dollars
  - Provide web3Modal={web3Modal}, loadWeb3Modal={loadWeb3Modal}, logoutOfWeb3Modal={logoutOfWeb3Modal}
              to be able to log in/log out to/from existing accounts
  - Provide blockExplorer={blockExplorer}, click on address and get the link
              (ex. by default "https://etherscan.io/" or for xdai "https://blockscout.com/poa/xdai/")
*/
const GASLESS_MODE_STORAGE_KEY = "GASLESS_MODE";
export default function Account({
  address,
  userProvider,
  localProvider,
  mainnetProvider,
  price,
  minimized,
  web3Modal,
  loadWeb3Modal,
  logoutOfWeb3Modal,
  blockExplorer,
  isSigner,
  toggleGaslessMode
}) {
  const [enableGaslessMode, setGaslessMode] = React.useState(true);

  useEffect(()=>{
    let gaslessModeFromStorage = localStorage.getItem(GASLESS_MODE_STORAGE_KEY);
    if(gaslessModeFromStorage && gaslessModeFromStorage === 'false') {
      setGaslessMode(false);
      if(toggleGaslessMode) {
        toggleGaslessMode(false);
      }
    }
  },[])
  const onSwitchGaslessMode = (event) => {
    let value = event.target.checked;
    setGaslessMode(value);
    localStorage.setItem(GASLESS_MODE_STORAGE_KEY, value);

    if(toggleGaslessMode) {
      toggleGaslessMode(value);
    }
  };

  const modalButtons = [];
  if (web3Modal) {
    if (web3Modal.cachedProvider) {
      modalButtons.push(
        <Button
          key="logoutbutton"
          style={{ verticalAlign: "top", marginLeft: 8, marginTop: 4 }}
          shape="round"
          size="large"
          onClick={logoutOfWeb3Modal}
        >
          logout
        </Button>,
      );
    } else {
      modalButtons.push(
        <Button
          key="loginbutton"
          style={{ verticalAlign: "top", marginLeft: 8, marginTop: 4 }}
          shape="round"
          size="large"
          /* type={minimized ? "default" : "primary"}     too many people just defaulting to MM and having a bad time */
          onClick={loadWeb3Modal}
        >
          connect
        </Button>,
      );
    }
  }

  const { currentTheme } = useThemeSwitcher();

  const display = minimized || !isSigner ? (
    ""
  ) : (
    <span>
      <span>Gasless Mode</span>
      <Switch
        checked={enableGaslessMode}
        onChange={onSwitchGaslessMode}
        color="primary"
        name="enableGaslessMode"
        inputProps={{ 'aria-label': 'primary checkbox' }}
      />
      {address ? (
        <Address address={address} ensProvider={mainnetProvider} blockExplorer={blockExplorer} />
      ) : (
        "Connecting..."
      )}
      <Balance address={address} provider={localProvider} price={price} />
      <Wallet
        address={address}
        provider={userProvider}
        ensProvider={mainnetProvider}
        price={price}
        color={currentTheme === "light" ? "#1890ff" : "#2caad9"}
      />
    </span>
  );

  return (
    <div>
      {display}
      {modalButtons}
    </div>
  );
}
