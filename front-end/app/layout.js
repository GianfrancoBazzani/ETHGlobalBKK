"use client";
import localFont from "next/font/local";
import { DynamicContextProvider, DynamicWidget } from "./lib/dynamic";
import { EthereumWalletConnectors } from "@dynamic-labs/ethereum";
import "./globals.css";
import Link from "next/link";

const geistSans = localFont({
  src: "./fonts/GeistVF.woff",
  variable: "--font-geist-sans",
  weight: "100 900",
});
const geistMono = localFont({
  src: "./fonts/GeistMonoVF.woff",
  variable: "--font-geist-mono",
  weight: "100 900",
});

//export const metadata = {
//  title: "Nomadica",
//  description: "Scroll Community Migration App",
//};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        <DynamicContextProvider
          settings={{
            environmentId: "57bc695d-32c1-4eec-87d1-d69ba0941f68",
            walletConnectors: [EthereumWalletConnectors],
          }}
        >
          <div className="flex justify-between items-center">
            <nav className="flex gap-6 p-4">
              <Link href="/bridge" className="text-purple-300 hover:text-pink-500 transition duration-300 ease-in-out font-bold text-lg">Bridge</Link>
              <Link href="/claim" className="text-purple-300 hover:text-pink-500 transition duration-300 ease-in-out font-bold text-lg">Claim</Link>
              <Link href="/migrate" className="text-purple-300 hover:text-pink-500 transition duration-300 ease-in-out font-bold text-lg">Migrate</Link>
            </nav>
            <div className="flex m-2">
              <DynamicWidget variant="modal" />
            </div>
          </div>
          <hr className="border-t border-purple-300 border-1" />
          {children}
          <hr className="border-t border-purple-300 border-1" />

        </DynamicContextProvider>
      </body>
    </html>
  );
}
