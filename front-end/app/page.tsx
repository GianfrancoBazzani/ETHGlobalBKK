"use client";

import { Suspense } from "react";
import Image from "next/image";
import { Button } from "flowbite-react";
import Link from "next/link";


export default function Home() {
  return (
    <div className="flex h-full w-full bg-gradient-to-r from-purple-500 to-pink-500">
      <main className="flex flex-col w-full gap-8 row-start-2 items-center sm:items-start p-10">
        <h1 className="text-4xl font-bold text-white">Welcome to MigratoooOooOoOR!</h1>
        <p className="text-xl text-purple-200">
          Migrate your community to Scroll L2 and unlock a universe of
          efficiency.
        </p>
        <Suspense fallback={<div>Loading...</div>}>
          <div className="w-full flex flex-row justify-end pr-64 gap-96">
            <div className="h-full flex flex-col justify-center">
            <Link href="/migrate" className="text-purple-300 hover:text-pink-500 transition duration-300 ease-in-out font-bold text-lg">
              <Button color="purple" gradientDuoTone="purpleToPink" className="border-gray-800 border-2">
                <span className="text-2xl">
                  Start Migration
                </span>
              </Button>
              </Link>
            </div>

            <Image
              src="/cube.webp"
              alt="Decorative cube"
              width={300}
              height={300}
            />
          </div>
        </Suspense>
      </main>
    </div>
  );
}
