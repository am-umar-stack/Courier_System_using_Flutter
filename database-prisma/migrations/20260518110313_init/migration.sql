-- CreateTable
CREATE TABLE `users` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `role` ENUM('ADMIN', 'DRIVER', 'CUSTOMER') NOT NULL DEFAULT 'CUSTOMER',
    `phone` VARCHAR(191) NULL,
    `avatarUrl` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `users_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `parcels` (
    `id` VARCHAR(191) NOT NULL,
    `items` VARCHAR(191) NOT NULL,
    `value` DECIMAL(10, 2) NOT NULL,
    `status` VARCHAR(191) NOT NULL,
    `receiver` VARCHAR(191) NOT NULL,
    `phone` VARCHAR(191) NOT NULL,
    `destination` VARCHAR(191) NOT NULL,
    `origin` VARCHAR(191) NOT NULL,
    `pin` VARCHAR(191) NOT NULL,
    `date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `driverId` INTEGER NULL,
    `customerId` INTEGER NULL,

    INDEX `parcels_driverId_idx`(`driverId`),
    INDEX `parcels_customerId_idx`(`customerId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `timeline_events` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `parcelId` VARCHAR(191) NOT NULL,
    `status` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NOT NULL,
    `timestamp` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `timeline_events_parcelId_idx`(`parcelId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `parcels` ADD CONSTRAINT `parcels_driverId_fkey` FOREIGN KEY (`driverId`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `parcels` ADD CONSTRAINT `parcels_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `timeline_events` ADD CONSTRAINT `timeline_events_parcelId_fkey` FOREIGN KEY (`parcelId`) REFERENCES `parcels`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
