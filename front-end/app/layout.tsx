"use client";

import React from "react";

import localFont from "next/font/local";
import { WagmiProvider } from "wagmi";
import {
    getDefaultConfig,
    RainbowKitProvider,
    darkTheme,
} from "@rainbow-me/rainbowkit";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { sepolia, scrollSepolia } from "viem/chains";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import "./globals.css";
import "@rainbow-me/rainbowkit/styles.css";
import Link from "next/link";
import { scrollDevnet } from "./lib/chains";

const config = getDefaultConfig({
    appName: "My RainbowKit App",
    projectId: "YOUR_PROJECT_ID",
    chains: [sepolia, scrollSepolia, scrollDevnet],
    ssr: false,
});

const queryClient = new QueryClient();

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
//  title: "MigratoooOooOoOR!",
//  description: "Scroll Community Migration App",
//};

export default function RootLayout({ children }: { children: React.ReactNode }) {
    return (
        <html lang="en">
            <body
                className={`${geistSans.variable} ${geistMono.variable} antialiased`}
            >
                <WagmiProvider config={config}>
                    <QueryClientProvider client={queryClient}>
                        <RainbowKitProvider
                            theme={darkTheme({
                                accentColor: "#7b3fe4",
                                accentColorForeground: "white",
                                borderRadius: "small",
                                fontStack: "system",
                                overlayBlur: "small",
                            })}
                        >
                            <div className="flex justify-between items-center">
                                <nav className="flex gap-6 p-4">
                                    <Link
                                        href="/bridge"
                                        className="text-purple-300 hover:text-pink-500 transition duration-300 ease-in-out font-bold text-lg"
                                    >
                                        Bridge
                                    </Link>
                                    <Link
                                        href="/claim"
                                        className="text-purple-300 hover:text-pink-500 transition duration-300 ease-in-out font-bold text-lg"
                                    >
                                        Claim
                                    </Link>
                                    <Link
                                        href="/migrate"
                                        className="text-purple-300 hover:text-pink-500 transition duration-300 ease-in-out font-bold text-lg"
                                    >
                                        Migrate
                                    </Link>
                                </nav>
                                <div className="flex m-2">
                                    <ConnectButton />
                                </div>
                            </div>
                            <hr className="border-t border-purple-300 border-1" />
                            {children}
                            <hr className="border-t border-purple-300 border-1" />
                        </RainbowKitProvider>
                    </QueryClientProvider>
                </WagmiProvider>
            </body>
        </html>
    );
}
